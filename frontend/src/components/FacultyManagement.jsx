import { useEffect, useMemo, useState } from 'react'

const API = import.meta.env.VITE_API_URL || 'http://localhost:8080/api'
const emptyForm = { name: '', organization: '', specialization: '', email: '', type: 'INTERNAL', status: 'ACTIVE' }

function FacultyManagement({ data, error, onReload }) {
  const [rows, setRows] = useState(data?.items || [])
  const [selected, setSelected] = useState(null)
  const [query, setQuery] = useState('')
  const [type, setType] = useState('')
  const [showForm, setShowForm] = useState(false)
  const [editing, setEditing] = useState(null)
  const [form, setForm] = useState(emptyForm)
  const [message, setMessage] = useState('')
  const [photo, setPhoto] = useState(null)
  useEffect(() => setRows(data?.items || []), [data])
  const visible = useMemo(() => rows.filter((row) => (!type || row.type === type) && (!query || JSON.stringify(row).toLowerCase().includes(query.toLowerCase()))), [rows, type, query])
  const internal = rows.filter((row) => row.type === 'INTERNAL').length
  const external = rows.filter((row) => row.type === 'EXTERNAL').length
  async function save(event) {
    event.preventDefault()
    const body = new FormData()
    Object.entries(form).forEach(([key, value]) => body.append(key, value))
    if (photo) body.append('photo', photo)
    const response = await fetch(`${API}/faculty${editing ? `/${editing.id}` : ''}`, { method: editing ? 'PUT' : 'POST', body })
    if (!response.ok) { setMessage('Unable to save faculty member.'); return }
    const saved = await response.json()
    setRows((current) => editing ? current.map((row) => row.id === saved.id ? saved : row) : [...current, saved])
    setSelected(saved); setShowForm(false); setEditing(null); setForm(emptyForm); setPhoto(null); setMessage('Faculty saved.')
    onReload?.()
  }
  async function remove(id) {
    if (!window.confirm('Delete this faculty member?')) return
    const response = await fetch(`${API}/faculty/${id}`, { method: 'DELETE' })
    if (!response.ok) { setMessage('Unable to delete faculty member.'); return }
    setRows((current) => current.filter((row) => row.id !== id)); setSelected(null); setMessage('Faculty deleted.'); onReload?.()
  }
  return <section className="faculty-page">
    <div className="page-heading"><div><div className="section-kicker">♟</div><h2>Faculty Management</h2><p>Manage internal and external faculty, their expertise, availability and assignments</p></div><div className="page-actions"><button type="button" className="action-secondary">⇩ Import Faculty</button><button type="button" className="action-primary" onClick={() => { setEditing(null); setForm(emptyForm); setShowForm(true) }}>＋ Add Faculty</button></div></div>
    {message && <p className="form-error">{message}</p>}{error && <p className="form-error">{error}</p>}
    <div className="faculty-stat-grid"><FacultyStat label="Total Faculty" value={rows.length} tone="blue" /><FacultyStat label="Internal Faculty" value={internal} tone="green" /><FacultyStat label="External Faculty" value={external} tone="blue" /><FacultyStat label="Total Subjects" value={[...new Set(rows.map((row) => row.specialization).filter(Boolean))].length} tone="purple" /></div>
    <div className="faculty-filters panel"><button type="button" className={type === '' ? 'active' : ''} onClick={() => setType('')}>♟ Faculty List</button><button type="button" onClick={() => setType('INTERNAL')}>Skills & Expertise</button><button type="button" onClick={() => setType('EXTERNAL')}>Availability</button><input placeholder="Search faculty by name, department, subject..." value={query} onChange={(event) => setQuery(event.target.value)} /><button type="button" className="filter-reset" onClick={() => { setQuery(''); setType('') }}>Reset</button></div>
    <div className="faculty-content-grid"><div className="panel faculty-list-panel"><div className="panel-title"><span className="panel-label">▣ Faculty List</span><span className="result-count">Showing {visible.length} of {rows.length} faculty</span></div><div className="employee-table-wrap"><table className="employee-table faculty-table"><thead><tr><th>#</th><th>Photo</th><th>Name</th><th>Type</th><th>Department / Organization</th><th>Expertise / Subject</th><th>Contact</th><th>Status</th><th>Actions</th></tr></thead><tbody>{visible.map((row, index) => <tr key={row.id} onClick={() => setSelected(row)}><td>{index + 1}</td><td>{row.photoUrl ? <img className="faculty-photo-thumb" src={`${API}${row.photoUrl.replace('/api', '')}`} alt="" /> : '—'}</td><td><strong>{row.name}</strong></td><td><span className={`faculty-type ${String(row.type).toLowerCase()}`}>{row.type}</span></td><td>{row.organization || '-'}</td><td>{row.specialization || '-'}</td><td>{row.email || '-'}</td><td><span className={`employee-status ${row.status === 'ACTIVE' ? '' : 'leave'}`}>{row.status || 'ACTIVE'}</span></td><td><button type="button" onClick={(event) => { event.stopPropagation(); setEditing(row); setForm({ name: row.name, organization: row.organization || '', specialization: row.specialization || '', email: row.email || '', type: row.type || 'INTERNAL', status: row.status || 'ACTIVE' }); setPhoto(null); setShowForm(true) }}>Edit</button><button type="button" onClick={(event) => { event.stopPropagation(); remove(row.id) }}>Delete</button></td></tr>)}{!visible.length && <tr><td colSpan="9" className="empty-table">No faculty records found in the database.</td></tr>}</tbody></table></div></div><aside className="panel faculty-details-panel"><div className="panel-title"><span className="panel-label">Faculty Details</span>{selected && <button type="button" className="close-detail" onClick={() => setSelected(null)}>×</button>}</div>{selected ? <><div className="faculty-detail-photo">{selected.photoUrl ? <img src={`${API}${selected.photoUrl.replace('/api', '')}`} alt="" /> : '—'}</div><h3>{selected.name}</h3><p>{selected.type} · {selected.organization || '-'}</p><dl className="detail-fields"><dt>Organization</dt><dd>{selected.organization || '-'}</dd><dt>Expertise</dt><dd>{selected.specialization || '-'}</dd><dt>Email</dt><dd>{selected.email || '-'}</dd><dt>Status</dt><dd><span className={`employee-status ${selected.status === 'ACTIVE' ? '' : 'leave'}`}>{selected.status || 'ACTIVE'}</span></dd></dl></> : <p className="empty-table">Select a faculty member to view details.</p>}</aside></div>
    <div className="faculty-lower-grid"><div className="panel"><div className="panel-title"><span className="panel-label">▣ Faculty Distribution</span></div><p>Internal {internal} · External {external}</p></div><div className="panel"><div className="panel-title"><span className="panel-label">▣ Top Expertise Areas</span></div>{[...new Set(rows.map((row) => row.specialization).filter(Boolean))].slice(0, 5).map((item) => <p key={item} className="faculty-expertise">{item}</p>)}</div></div>
    {showForm && <div className="employee-modal-backdrop"><form className="employee-modal" onSubmit={save}><div className="panel-title"><span className="panel-label">{editing ? 'Edit Faculty' : 'Add Faculty'}</span><button type="button" className="close-detail" onClick={() => setShowForm(false)}>×</button></div><label>Name<input required value={form.name} onChange={(event) => setForm({ ...form, name: event.target.value })} /></label><label>Organization<input required value={form.organization} onChange={(event) => setForm({ ...form, organization: event.target.value })} /></label><label>Expertise / Subject<input required value={form.specialization} onChange={(event) => setForm({ ...form, specialization: event.target.value })} /></label><label>Email<input type="email" value={form.email} onChange={(event) => setForm({ ...form, email: event.target.value })} /></label><label>Type<select value={form.type} onChange={(event) => setForm({ ...form, type: event.target.value })}><option>INTERNAL</option><option>EXTERNAL</option></select></label><label>Status<select value={form.status} onChange={(event) => setForm({ ...form, status: event.target.value })}><option value="ACTIVE">Active</option><option value="INACTIVE">Inactive</option><option value="ON_LEAVE">On Leave</option></select></label><label>Photo<input type="file" accept="image/*" onChange={(event) => setPhoto(event.target.files?.[0] || null)} /></label><button type="submit" className="action-primary">Save Faculty</button></form></div>}
  </section>
}

function FacultyStat({ label, value, tone }) { return <article className={`faculty-stat ${tone}`}><span>{label}</span><strong>{value}</strong><small>From database</small></article> }
export default FacultyManagement
