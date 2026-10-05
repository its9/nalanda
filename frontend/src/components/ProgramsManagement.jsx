import { useEffect, useMemo, useState } from 'react'
import { getResource } from '../api/dashboardApi'
import ConfirmDialog from './ConfirmDialog'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api'
const emptyForm = { batchNumber: '', code: '', name: '', coordinator: '', unit: '', hall: '', type: 'INTERNAL', status: 'PLANNED', startDate: '', endDate: '', hoursPerDay: 8 }

async function saveProgram(method, id, form) {
  const response = await fetch(`${API_BASE_URL}/programs${id ? `/${id}` : ''}`, { method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ ...form, hoursPerDay: Number(form.hoursPerDay) }) })
  const body = await response.text()
  let data = {}
  try { data = body ? JSON.parse(body) : {} } catch { /* The server may return plain text for an error. */ }
  if (!response.ok) throw new Error(data.message || body || `Program request failed: ${response.status}`)
  return data
}

function ProgramsManagement({ onApiState }) {
  const [programs, setPrograms] = useState([])
  const [halls, setHalls] = useState([])
  const [selected, setSelected] = useState(null)
  const [filters, setFilters] = useState({ hall: '', type: '', status: '' })
  const [showForm, setShowForm] = useState(false)
  const [editing, setEditing] = useState(null)
  const [form, setForm] = useState(emptyForm)
  const [error, setError] = useState('')
  const [confirmDelete, setConfirmDelete] = useState(false)

  function loadPrograms() {
    getResource('/programs').then((response) => { setPrograms(response.items || []); onApiState('connected') }).catch(() => onApiState('offline'))
  }

  useEffect(() => {
    loadPrograms()
    getResource('/halls').then((response) => setHalls(response.items || [])).catch(() => setHalls([]))
  }, [])

  const statusClass = (status) => `program-status ${String(status || '').toLowerCase()}`
  const visiblePrograms = useMemo(() => programs.filter((program) => (!filters.hall || program.hall === filters.hall) && (!filters.type || program.type === filters.type) && (!filters.status || program.status === filters.status)), [programs, filters])
  const counts = { total: programs.length, ongoing: programs.filter((item) => item.status === 'ONGOING').length, upcoming: programs.filter((item) => ['PLANNED', 'SCHEDULED'].includes(item.status)).length, completed: programs.filter((item) => item.status === 'COMPLETED').length, cancelled: programs.filter((item) => item.status === 'CANCELLED').length }

  function openCreate() { setEditing(null); setForm(emptyForm); setError(''); setShowForm(true) }
  function openEdit() { if (!selected) return; setEditing(selected); setForm({ ...emptyForm, ...selected }); setError(''); setShowForm(true) }
  async function submit(event) { event.preventDefault(); setError(''); try { const saved = await saveProgram(editing ? 'PUT' : 'POST', editing?.id, form); setPrograms((current) => editing ? current.map((item) => item.id === saved.id ? saved : item) : [...current, saved]); setSelected(saved); setShowForm(false) } catch (requestError) { setError(requestError.message) } }
  async function deleteProgram() { if (selected) setConfirmDelete(true) }
  async function confirmProgramDelete() { const response = await fetch(`${API_BASE_URL}/programs/${selected.id}`, { method: 'DELETE' }); if (!response.ok) { setError('Unable to delete this program.'); return } setPrograms((current) => current.filter((item) => item.id !== selected.id)); setSelected(null); setConfirmDelete(false) }
  async function changeStatus(action) { if (!selected) return; const response = await fetch(`${API_BASE_URL}/programs/${selected.id}/${action}`, { method: 'PUT' }); if (!response.ok) return; const updated = await response.json(); setPrograms((current) => current.map((item) => item.id === updated.id ? updated : item)); setSelected(updated) }

  return <section className="programs-page">
    <div className="page-heading"><div><div className="section-kicker">▣</div><h2>Programs Management</h2><p>Create, manage and track training programs</p></div><div className="page-actions"><button type="button" className="action-primary" onClick={openCreate}>＋ Add Program</button><button type="button" className="action-secondary" onClick={deleteProgram} disabled={!selected}>Delete Program</button><button type="button" className="action-secondary">↥ Import (Excel)</button><button type="button" className="action-secondary">▣ Export</button></div></div>
    <div className="program-stat-grid"><ProgramStat label="Total Programs" value={counts.total} tone="blue" /><ProgramStat label="Ongoing Programs" value={counts.ongoing} tone="green" /><ProgramStat label="Upcoming Programs" value={counts.upcoming} tone="orange" /><ProgramStat label="Completed Programs" value={counts.completed} tone="teal" /><ProgramStat label="Cancelled Programs" value={counts.cancelled} tone="red" /></div>
    <div className="program-filters panel"><label>Hall<select value={filters.hall} onChange={(event) => setFilters({ ...filters, hall: event.target.value })}><option value="">All Halls</option>{[...new Set(programs.map((item) => item.hall).filter(Boolean))].map((item) => <option key={item}>{item}</option>)}</select></label><label>Program Type<select value={filters.type} onChange={(event) => setFilters({ ...filters, type: event.target.value })}><option value="">All Types</option><option>INTERNAL</option><option>EXTERNAL</option></select></label><label>Status<select value={filters.status} onChange={(event) => setFilters({ ...filters, status: event.target.value })}><option value="">All Status</option>{['PLANNED', 'SCHEDULED', 'ONGOING', 'COMPLETED', 'CANCELLED'].map((item) => <option key={item}>{item}</option>)}</select></label><button type="button" className="filter-apply" onClick={loadPrograms}>Apply</button><button type="button" className="filter-reset" onClick={() => setFilters({ hall: '', type: '', status: '' })}>Reset</button></div>
    <div className="program-content-grid"><div className="panel program-list-panel"><div className="panel-title"><span className="panel-label">▣ &nbsp; Program List</span><span className="result-count">Showing {visiblePrograms.length} of {programs.length} programs</span></div><div className="employee-table-wrap"><table className="employee-table program-table"><thead><tr><th>#</th><th>Program ID</th><th>Program Name</th><th>Type</th><th>Hall</th><th>Status</th><th>Days</th></tr></thead><tbody>{visiblePrograms.length ? visiblePrograms.map((program, index) => <tr key={program.id} onClick={() => setSelected(program)}><td>{index + 1}</td><td>{program.code}</td><td>{program.name}</td><td>{program.type}</td><td>{program.hall || '-'}</td><td><span className={statusClass(program.status)}>{program.status}</span></td><td>{program.programDays || '-'}</td></tr>) : <tr><td colSpan="7" className="empty-table">No programs found in the database.</td></tr>}</tbody></table></div></div><aside className="panel program-detail-panel"><div className="panel-title"><span className="panel-label">▣ &nbsp; Program Details</span><button type="button" className="close-detail" onClick={() => setSelected(null)}>×</button></div>{selected ? <><div className="program-detail-hero">{selected.name}</div><dl className="detail-fields"><dt>Program ID</dt><dd>{selected.code}</dd><dt>Program Name</dt><dd>{selected.name}</dd><dt>Program Type</dt><dd>{selected.type}</dd><dt>Hall</dt><dd>{selected.hall || '-'}</dd><dt>Status</dt><dd><span className={statusClass(selected.status)}>{selected.status}</span></dd><dt>Start Date</dt><dd>{selected.startDate || '-'}</dd><dt>End Date</dt><dd>{selected.endDate || '-'}</dd><dt>Duration</dt><dd>{selected.programDays || '-'} Days</dd><dt>Hours / Day</dt><dd>{selected.hoursPerDay || '-'}</dd></dl><div className="program-detail-actions"><button type="button" onClick={openEdit}>✎ Edit</button><button type="button" onClick={() => changeStatus('start')}>Start</button><button type="button" onClick={() => changeStatus('complete')}>Complete</button><button type="button" className="delete-action" onClick={deleteProgram}>Delete</button></div></> : <p className="empty-table">Select a program to view details.</p>}</aside></div>
    {showForm && <ProgramForm form={form} setForm={setForm} halls={halls} programs={programs} editing={editing} error={error} onClose={() => setShowForm(false)} onSubmit={submit} />}
    {confirmDelete && <ConfirmDialog message={`Delete program "${selected.name}"?`} onCancel={() => setConfirmDelete(false)} onConfirm={confirmProgramDelete} />}
  </section>
}

function ProgramForm({ form, setForm, halls, programs, editing, error, onClose, onSubmit }) {
  const fields = [['name', 'Program Name'], ['code', 'Program Code'], ['batchNumber', 'Batch Number']]
  const scheduled = !['PLANNED', 'CANCELLED'].includes(form.status)
  const selectedHall = halls.find((hall) => hall.name === form.hall)
  const dateAwareStatus = (hall) => {
    if (!hall) return ''
    if (!form.startDate || !form.endDate || !scheduled) return 'SELECT DATES'
    const overlaps = (program) => program.id !== editing?.id && program.hall === hall.name
      && ['SCHEDULED', 'ONGOING'].includes(program.status)
      && program.startDate && program.endDate
      && program.startDate <= form.endDate && program.endDate >= form.startDate
    return programs.some(overlaps) ? 'BOOKED' : 'AVAILABLE'
  }
  const calculatedDays = form.startDate && form.endDate ? Math.max(0, Math.round((new Date(`${form.endDate}T00:00:00`) - new Date(`${form.startDate}T00:00:00`)) / 86400000) + 1) : 0
  return <div className="employee-modal-backdrop"><form className="employee-modal program-modal" onSubmit={onSubmit}><div className="panel-title"><span className="panel-label">{editing ? 'Edit Program' : 'Add Program'}</span><button type="button" className="close-detail" onClick={onClose}>×</button></div>{fields.map(([key, label]) => <label key={key}>{label}<input required value={form[key] || ''} onChange={(event) => setForm({ ...form, [key]: event.target.value })} /></label>)}<label>Type<select value={form.type} onChange={(event) => setForm({ ...form, type: event.target.value })}><option>INTERNAL</option><option>EXTERNAL</option></select></label><label>Status<select value={form.status} onChange={(event) => { const status = event.target.value; setForm({ ...form, status, ...(status === 'PLANNED' || status === 'CANCELLED' ? { startDate: '', endDate: '' } : {}) }) }}>{['PLANNED', 'SCHEDULED', 'ONGOING', 'COMPLETED', 'CANCELLED'].map((item) => <option key={item}>{item}</option>)}</select></label>{scheduled && <div className="program-form-row"><label>Start Date<input required type="date" value={form.startDate || ''} onChange={(event) => setForm({ ...form, startDate: event.target.value })} /></label><label>End Date<input required type="date" min={form.startDate || undefined} value={form.endDate || ''} onChange={(event) => setForm({ ...form, endDate: event.target.value })} /></label></div>}<label>Hall<select value={form.hall || ''} onChange={(event) => setForm({ ...form, hall: event.target.value })}><option value="">Select Hall</option>{halls.map((hall) => { const availability = dateAwareStatus(hall); return <option key={hall.id} value={hall.name} disabled={scheduled && form.startDate && form.endDate && availability !== 'AVAILABLE' && hall.name !== form.hall}>{hall.name} ({hall.capacity}) - {availability}</option> })}</select>{selectedHall && <small className={`program-hall-status ${dateAwareStatus(selectedHall) === 'AVAILABLE' ? 'available' : 'unavailable'}`}>Selected hall: {selectedHall.name} — {dateAwareStatus(selectedHall)}</small>}</label><small className="program-hall-help">Select dates to check hall availability for that date range.</small><div className="program-form-row"><label>Program Days<input readOnly value={calculatedDays || ''} placeholder="Calculated from dates" /></label><label>Hours / Day<input required type="number" min="1" value={form.hoursPerDay || ''} onChange={(event) => setForm({ ...form, hoursPerDay: event.target.value })} /></label></div>{error && <p className="form-error">{error}</p>}<button type="submit" className="action-primary">{editing ? 'Update Program' : 'Save Program'}</button></form></div>
}

function ProgramStat({ label, value, tone }) { return <div className={`employee-stat ${tone}`}><span className="employee-stat-icon">●</span><div><span>{label}</span><strong>{value}</strong><small>From database</small></div></div> }

export default ProgramsManagement