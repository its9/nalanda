import { useEffect, useMemo, useRef, useState } from 'react'
import { getResource } from '../api/dashboardApi'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api'

function NominationsManagement({ data, error }) {
  const [rows, setRows] = useState(data?.items || [])
  const [status, setStatus] = useState('')
  const [query, setQuery] = useState('')
  const [selected, setSelected] = useState(null)
  const [program, setProgram] = useState('')
  const [programs, setPrograms] = useState([])
  const [message, setMessage] = useState('')
  const [employees, setEmployees] = useState([])
  const [showAdd, setShowAdd] = useState(false)
  const [employeeId, setEmployeeId] = useState('')
  const [employeeSearch, setEmployeeSearch] = useState('')
  const fileInput = useRef(null)
  useEffect(() => {
    setRows(data?.items || [])
    getResource('/programs').then((response) => setPrograms(response.items || [])).catch(() => setPrograms([]))
    getResource('/employees').then((response) => setEmployees(response.items || [])).catch(() => setEmployees([]))
  }, [])
  async function changeStatus(id, nextStatus) {
    const response = await fetch(`${API_BASE_URL}/nominations/${id}/${nextStatus === 'APPROVED' ? 'approve' : 'cancel'}`, { method: 'PUT' })
    const result = await response.json().catch(() => ({}))
    if (!response.ok) {
      setMessage(result.message || 'Unable to update nomination status.')
      return
    }
    setRows((current) => current.map((row) => row.id === id ? { ...row, status: nextStatus } : row))
    setSelected((current) => current?.id === id ? { ...current, status: nextStatus } : current)
    setMessage(`Nomination ${nextStatus.toLowerCase()}.`)
  }
  async function addEmployee() {
    if (!program || !employeeId) return setMessage('Select a program and employee first.')
    const response = await fetch(`${API_BASE_URL}/nominations`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ programId: Number(program), employeeId: Number(employeeId), status: 'PENDING' }) })
    const result = await response.json().catch(() => ({}))
    setMessage(response.ok ? 'Employee added to the program.' : (result.message || 'Unable to add employee.'))
    if (response.ok) setShowAdd(false)
  }
  const visible = useMemo(() => rows.filter((row) =>
    (!status || row.status === status) &&
    (!program || String(row.programId) === program) &&
    (!query || JSON.stringify(row).toLowerCase().includes(query.toLowerCase()))), [rows, status, program, query])
  const count = (value) => rows.filter((row) => row.status === value).length
  const cards = [['Total Nominations', rows.length, 'blue'], ['Approved', count('APPROVED'), 'green'], ['Pending', count('PENDING'), 'orange'], ['Cancelled', count('CANCELLED'), 'red']]

  return <section className="nominations-page">
    <div className="page-heading"><div><div className="section-kicker">♟</div><h2>Nomination Management</h2><p>Manage nominations for training programs</p></div><div className="page-actions"><button type="button" className="action-primary" onClick={() => setShowAdd(true)}>＋ Add Employee to Program</button><button type="button" className="action-secondary" onClick={() => fileInput.current?.click()}>⇩ Upload Employee List (Excel)</button><input ref={fileInput} hidden type="file" accept=".csv,.xlsx,.xls" onChange={async (event) => { const file = event.target.files?.[0]; if (!file) return; if (!program) { setMessage('Select a program before uploading the employee list.'); event.target.value = ''; return } const body = new FormData(); body.append('file', file); body.append('programId', program); const response = await fetch(`${API_BASE_URL}/nominations/import`, { method: 'POST', body }); const result = await response.json().catch(() => ({})); setMessage(response.ok ? `${result.created || 0} employee nominations imported.` : (result.message || 'Unable to import the employee list.')); event.target.value = '' }} /><button type="button" className="action-secondary">Export</button></div></div>
    <div className="nomination-stat-grid">{cards.map(([label, value, tone]) => <article className={`nomination-stat ${tone}`} key={label}><span>{label}</span><strong>{value}</strong><small>From database</small></article>)}</div>
    {message && <p className="form-error">{message}</p>}<div className="nomination-filters panel"><label>Program<select value={program} onChange={(event) => setProgram(event.target.value)}><option value="">All Programs</option>{programs.map((item) => <option key={item.id} value={item.id}>{item.name} ({item.code})</option>)}</select></label><label>Nomination Status<select value={status} onChange={(event) => setStatus(event.target.value)}><option value="">All</option><option>APPROVED</option><option>PENDING</option><option>CANCELLED</option></select></label><input placeholder="Search by employee name or ID..." value={query} onChange={(event) => setQuery(event.target.value)} /><button type="button" className="filter-apply">Apply</button><button type="button" className="filter-reset" onClick={() => { setStatus(''); setProgram(''); setQuery('') }}>Reset</button></div>
    <div className="nomination-content-grid"><div className="panel nomination-list-panel"><div className="panel-title"><span className="panel-label">▣ Nomination List</span><span className="result-count">Showing {visible.length} of {data?.total ?? rows.length} entries</span></div>{error && <p className="empty-table">{error}</p>}{!error && <div className="employee-table-wrap"><table className="employee-table nomination-table"><thead><tr><th>#</th><th>Employee ID</th><th>Employee Name</th><th>Nomination Date</th><th>Status</th><th>Actions</th></tr></thead><tbody>{visible.map((row, index) => <tr key={row.id || index} onClick={() => setSelected(row)}><td>{index + 1}</td><td>{row.employeeNumber || row.employeeId || '-'}</td><td>{row.employeeName || '-'}</td><td>{row.nominationDate || row.createdAt || '-'}</td><td><span className={`nomination-status ${String(row.status || '').toLowerCase()}`}>{row.status || '-'}</span></td><td>{row.status === 'PENDING' ? <span className="nomination-row-actions"><button type="button" onClick={(event) => { event.stopPropagation(); changeStatus(row.id, 'APPROVED') }}>Approve</button><button type="button" onClick={(event) => { event.stopPropagation(); changeStatus(row.id, 'CANCELLED') }}>Cancel</button></span> : '-'}</td></tr>)}{!visible.length && <tr><td colSpan="6" className="empty-table">No nominations found in the database.</td></tr>}</tbody></table></div>}</div><aside className="panel nomination-details-panel"><div className="panel-title"><span className="panel-label">▣ Nomination Details</span><button type="button" className="close-detail" onClick={() => setSelected(null)}>×</button></div>{selected ? <><dl className="detail-fields"><dt>Employee ID</dt><dd>{selected.employeeNumber || selected.employeeId || '-'}</dd><dt>Employee Name</dt><dd>{selected.employeeName || '-'}</dd><dt>Status</dt><dd><span className={`nomination-status ${String(selected.status || '').toLowerCase()}`}>{selected.status}</span></dd><dt>Nomination Date</dt><dd>{selected.nominationDate || selected.createdAt || '-'}</dd></dl>{selected.status === 'PENDING' && <div className="nomination-decision-actions"><button type="button" onClick={() => changeStatus(selected.id, 'APPROVED')}>Approve</button><button type="button" onClick={() => changeStatus(selected.id, 'CANCELLED')}>Cancel</button></div>}</> : <p className="empty-table">Select a nomination to view details.</p>}</aside></div>
    {showAdd && <div className="employee-modal-backdrop"><form className="employee-modal" onSubmit={(event) => { event.preventDefault(); addEmployee() }}><div className="panel-title"><span className="panel-label">Add Employee to Program</span><button type="button" className="close-detail" onClick={() => setShowAdd(false)}>×</button></div><label>Program<select required value={program} onChange={(event) => setProgram(event.target.value)}><option value="">Select program</option>{programs.map((item) => <option key={item.id} value={item.id}>{item.name} ({item.startDate || '-'} to {item.endDate || '-'})</option>)}</select></label><label>Search Employee<input required list="employee-options" placeholder="Search by employee number or name" value={employeeSearch} onChange={(event) => { const value = event.target.value; setEmployeeSearch(value); const match = employees.find((item) => `${item.employeeNumber || item.employeeId} - ${item.name || item.employeeName}` === value); setEmployeeId(match ? String(match.id) : '') }} /><datalist id="employee-options">{employees.map((item) => <option key={item.id} value={`${item.employeeNumber || item.employeeId} - ${item.name || item.employeeName}`} />)}</datalist></label><button type="submit" className="action-primary">Add Employee</button></form></div>}
  </section>
}

export default NominationsManagement
