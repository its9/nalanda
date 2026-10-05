import { useEffect, useMemo, useState } from 'react'
import { getAttendance, getNominatedAttendance, getNominatedProgramAttendance, getPrograms, saveAttendance } from '../api/dashboardApi'

function AttendanceManagement({ onApiState }) {
  const [programs, setPrograms] = useState([])
  const [records, setRecords] = useState([])
  const [selected, setSelected] = useState(null)
  const [filters, setFilters] = useState({ from: '', to: '', program: '', status: '' })
  const [employeeNumber, setEmployeeNumber] = useState('')
  const [attendanceDate, setAttendanceDate] = useState(new Date().toISOString().slice(0, 10))
  const [nominated, setNominated] = useState([])
  const [programNominated, setProgramNominated] = useState([])
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')

  async function load() {
    try {
      const [programData, attendanceData] = await Promise.all([getPrograms(), getAttendance()])
      setPrograms(programData.items || [])
      setRecords(attendanceData.items || [])
      onApiState('connected')
    } catch (requestError) {
      setError(requestError.message)
      onApiState('offline')
    }
  }

  useEffect(() => { load() }, [])

  useEffect(() => {
    if (!filters.program) {
      setProgramNominated([])
      return
    }
    getNominatedProgramAttendance(filters.program, filters.from || attendanceDate)
      .then((response) => setProgramNominated(response.items || []))
      .catch((requestError) => setError(requestError.message))
  }, [filters.program, filters.from, attendanceDate])

  const programById = useMemo(() => new Map(programs.map((program) => [String(program.id), program])), [programs])
  const visible = useMemo(() => records.filter((record) => {
    const date = record.date || ''
    return (!filters.from || date >= filters.from) && (!filters.to || date <= filters.to)
      && (!filters.program || String(record.programId) === filters.program)
      && (!filters.status || String(record.status).toUpperCase() === filters.status)
  }), [records, filters])
  const displayed = filters.program && programNominated.length ? programNominated.filter((record) => (
    (!filters.status || String(record.status).toUpperCase() === filters.status)
  )) : visible

  const stats = useMemo(() => {
    const participants = new Set(records.map((record) => record.employeeId)).size
    const present = records.filter((record) => String(record.status).toUpperCase() === 'PRESENT').length
    const absent = records.filter((record) => String(record.status).toUpperCase() === 'ABSENT').length
    const sessions = new Set(records.map((record) => record.programId)).size
    return { participants, present, absent, sessions, percentage: records.length ? (present / records.length) * 100 : 0 }
  }, [records])

  async function findEmployee(event) {
    event.preventDefault()
    setError('')
    setMessage('')
    try {
      const result = await getNominatedAttendance(employeeNumber.trim())
      setNominated(result.items || [])
      if (!result.items?.length) setMessage('No nominated program was found for this employee.')
    } catch (requestError) {
      setError(requestError.message)
    }
  }

  async function mark(item, status) {
    try {
      await saveAttendance({ programId: item.programId, employeeId: item.employeeId, date: attendanceDate, status, remarks: item.remarks || '' })
      setMessage(`${item.employeeName} marked ${status.toLowerCase()}.`)
      await load()
      await findEmployee({ preventDefault() {} })
      if (filters.program) {
        const result = await getNominatedProgramAttendance(filters.program, filters.from || attendanceDate)
        setProgramNominated(result.items || [])
      }
    } catch (requestError) {
      setError(requestError.message)
    }
  }

  function resetFilters() {
    setFilters({ from: '', to: '', program: '', status: '' })
  }

  return <section className="attendance-page">
    <div className="page-heading"><div><div className="section-kicker">▣</div><h2>Attendance Management</h2><p>Mark, view and analyze attendance for all training programs</p></div><div className="page-actions"><button type="button" className="action-primary" onClick={() => document.getElementById('attendance-employee')?.focus()}>＋ Mark Attendance</button><button type="button" className="action-secondary">↥ Upload from Excel</button><button type="button" className="action-secondary">▣ Export</button></div></div>
    {error && <p className="settings-feedback error-message">{error}</p>}{message && <p className="settings-feedback">{message}</p>}
    <div className="attendance-stat-grid attendance-stat-grid-five"><AttendanceStat label="Total Participants" value={stats.participants.toLocaleString()} note="in selected period" tone="blue" /><AttendanceStat label="Present" value={stats.present.toLocaleString()} note={`${records.length ? ((stats.present / records.length) * 100).toFixed(1) : '0.0'}%`} tone="green" /><AttendanceStat label="Absent" value={stats.absent.toLocaleString()} note={`${records.length ? ((stats.absent / records.length) * 100).toFixed(1) : '0.0'}%`} tone="red" /><AttendanceStat label="Total Sessions" value={stats.sessions} note="from database" tone="blue" /><AttendanceStat label="Average Attendance" value={`${stats.percentage.toFixed(1)}%`} note="live calculation" tone="green" /></div>
    <div className="attendance-filters panel"><label>Date From<input type="date" value={filters.from} onChange={(event) => setFilters({ ...filters, from: event.target.value })} /></label><label>Date To<input type="date" value={filters.to} onChange={(event) => setFilters({ ...filters, to: event.target.value })} /></label><label>Program<select value={filters.program} onChange={(event) => setFilters({ ...filters, program: event.target.value })}><option value="">All Programs</option>{programs.map((program) => <option key={program.id} value={program.id}>{program.name}</option>)}</select></label><label>Attendance Status<select value={filters.status} onChange={(event) => setFilters({ ...filters, status: event.target.value })}><option value="">All</option><option value="PRESENT">Present</option><option value="ABSENT">Absent</option></select></label><button type="button" className="filter-apply">Apply</button><button type="button" className="filter-reset" onClick={resetFilters}>Reset</button></div>
    <div className="attendance-content-grid"><div className="panel attendance-records-panel"><div className="panel-title"><span className="panel-label">▣ {filters.program ? 'Nominated Employees' : 'Attendance Records'}</span><span className="result-count">Showing {displayed.length} entries</span></div><div className="employee-table-wrap"><table className="employee-table attendance-table"><thead><tr><th>□</th><th>#</th><th>Date</th><th>Program Name</th><th>Employee ID</th><th>Employee Name</th><th>Status</th><th>Remarks</th>{filters.program && <th>Actions</th>}</tr></thead><tbody>{displayed.map((record, index) => <tr key={`${record.id}-${record.employeeId}`} onClick={() => setSelected(record)}><td>□</td><td>{index + 1}</td><td>{record.date || '-'}</td><td>{record.programName || programById.get(String(record.programId))?.name || '-'}</td><td>{record.employeeNumber || record.employeeId}</td><td>{record.employeeName || '-'}</td><td><span className={`attendance-badge ${String(record.status).toLowerCase()}`}>{record.status}</span></td><td>{record.remarks || '-'}</td>{filters.program && <td><button type="button" className="attendance-present" onClick={(event) => { event.stopPropagation(); mark({ ...record, date: filters.from || attendanceDate }, 'PRESENT') }}>Present</button><button type="button" className="attendance-absent" onClick={(event) => { event.stopPropagation(); mark({ ...record, date: filters.from || attendanceDate }, 'ABSENT') }}>Absent</button></td>}</tr>)}{!displayed.length && <tr><td colSpan={filters.program ? 9 : 8} className="empty-table">{filters.program ? 'No nominated employees found for this program.' : 'No attendance records found in the database.'}</td></tr>}</tbody></table></div></div><aside className="panel attendance-session-panel"><div className="panel-title"><span className="panel-label">▣ Session Details</span>{selected && <button type="button" className="close-detail" onClick={() => setSelected(null)}>×</button>}</div>{selected ? <dl className="detail-fields"><dt>Program Name</dt><dd>{selected.programName || '-'}</dd><dt>Date</dt><dd>{selected.date || '-'}</dd><dt>Employee</dt><dd>{selected.employeeName || '-'}</dd><dt>Status</dt><dd><span className={`attendance-badge ${String(selected.status).toLowerCase()}`}>{selected.status}</span></dd><dt>Remarks</dt><dd>{selected.remarks || '-'}</dd></dl> : <p className="empty-table">Select a record to view session details.</p>}</aside></div>
    <div className="attendance-lower-grid"><div className="panel attendance-chart-panel"><div className="panel-title"><span className="panel-label">▣ Attendance by Program</span></div>{programs.slice(0, 6).map((program) => { const rows = records.filter((record) => String(record.programId) === String(program.id)); const present = rows.filter((record) => String(record.status).toUpperCase() === 'PRESENT').length; const percent = rows.length ? Math.round((present / rows.length) * 100) : 0; return <div className="attendance-program-bar" key={program.id}><span>{program.name}</span><i><b style={{ width: `${percent}%` }} /></i><strong>{percent}%</strong></div> })}{!programs.length && <p className="empty-table">No programs found.</p>}</div><div className="panel attendance-update-panel"><div className="panel-title"><span className="panel-label">▣ Quick Mark Attendance</span></div><form onSubmit={findEmployee}><label>Employee ID<input id="attendance-employee" value={employeeNumber} onChange={(event) => setEmployeeNumber(event.target.value)} placeholder="Employee ID" required /></label><label>Attendance Date<input type="date" value={attendanceDate} onChange={(event) => setAttendanceDate(event.target.value)} required /></label><button type="submit" className="action-primary">Find Nominated Programs</button></form>{nominated.map((item) => <div className="attendance-nomination" key={`${item.programId}-${item.employeeId}`}><strong>{item.programName}</strong><span>{item.employeeName} · {item.employeeNumber}</span><div><button type="button" className="attendance-present" onClick={() => mark(item, 'PRESENT')}>Present</button><button type="button" className="attendance-absent" onClick={() => mark(item, 'ABSENT')}>Absent</button></div></div>)}</div></div>
  </section>
}

function AttendanceStat({ label, value, note, tone }) {
  return <div className={`attendance-stat-card ${tone}`}><span className="attendance-stat-icon">●</span><div><span>{label}</span><strong>{value}</strong><small>{note}</small></div></div>
}

export default AttendanceManagement
