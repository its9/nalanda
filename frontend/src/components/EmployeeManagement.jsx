import { useEffect, useMemo, useRef, useState } from 'react'
import { createEmployee, deleteEmployee, exportEmployees, getEmployeeOptions, getEmployees, searchEmployees, updateEmployee, uploadEmployees } from '../api/dashboardApi'
import ConfirmDialog from './ConfirmDialog'

function EmployeeManagement({ onApiState, searchQuery = '' }) {
  const [employees, setEmployees] = useState([])
  const [employeeOptions, setEmployeeOptions] = useState({ units: [], departments: {} })
  const [filters, setFilters] = useState({ department: '', unit: '' })
  const [selected, setSelected] = useState(null)
  const [showForm, setShowForm] = useState(false)
  const [editingEmployee, setEditingEmployee] = useState(null)
  const [formError, setFormError] = useState('')
  const [confirmDelete, setConfirmDelete] = useState(false)
  const [importMessage, setImportMessage] = useState('')
  const importInput = useRef(null)
  const [form, setForm] = useState({ employeeId: '', name: '', department: '', unit: '', email: '', phone: '', internalPhone: '', designation: '', joiningDate: '', status: 'ACTIVE' })

  useEffect(() => {
    const loadEmployees = searchQuery ? searchEmployees(searchQuery) : getEmployees()
    loadEmployees
      .then((response) => {
        setEmployees(response.items || [])
        onApiState('connected')
      })
      .catch(() => {
        setEmployees([])
        onApiState('offline')
      })
  }, [onApiState, searchQuery])

  useEffect(() => {
    getEmployeeOptions().then(setEmployeeOptions).catch(() => {})
  }, [])

  const visibleEmployees = useMemo(() => employees.filter((employee) => (
    (!filters.department || employee.department === filters.department) &&
    (!filters.unit || employee.unit === filters.unit)
  )), [employees, filters])

  const departments = [...new Set(employees.map((employee) => employee.department))]
  const units = [...new Set(employees.map((employee) => employee.unit))]
  const activeCount = employees.filter((employee) => employee.status !== 'On Leave').length
  const leaveCount = employees.filter((employee) => employee.status === 'On Leave').length

  async function submitEmployee(event) {
    event.preventDefault()
    setFormError('')
    try {
      const employee = editingEmployee
        ? await updateEmployee(editingEmployee.id, form)
        : await createEmployee(form)
      setEmployees((current) => editingEmployee
        ? current.map((item) => item.id === employee.id ? employee : item)
        : [...current, employee])
      setSelected(employee)
      setForm({ employeeId: '', name: '', department: '', unit: '', email: '', phone: '', internalPhone: '', designation: '', joiningDate: '', status: 'ACTIVE' })
      setEditingEmployee(null)
      setShowForm(false)
    } catch (error) {
      setFormError(error.message)
    }
  }

  async function handleImport(event) {
    const file = event.target.files?.[0]
    event.target.value = ''
    if (!file) return
    setImportMessage('Importing employees...')
    try {
      const result = await uploadEmployees(file)
      const response = await getEmployees()
      setEmployees(response.items || [])
      setImportMessage(result.message)
      onApiState('connected')
    } catch (error) {
      setImportMessage(error.message)
    }
  }

  async function handleExport() {
    try {
      await exportEmployees()
    } catch (error) {
      setImportMessage(error.message)
    }
  }

  async function handleDelete() {
    if (!selected) return
    setConfirmDelete(true)
  }

  async function confirmEmployeeDelete() {
    try {
      await deleteEmployee(selected.id)
      setEmployees((current) => current.filter((item) => item.id !== selected.id))
      setSelected(null)
      setConfirmDelete(false)
    } catch (error) {
      setImportMessage(error.message)
    }
  }

  function openEditForm() {
    if (!selected) return
    setEditingEmployee(selected)
    setForm({
      employeeId: selected.employeeId || '',
      name: selected.name || '',
      department: selected.department || '',
      unit: selected.unit || '',
      email: selected.email || '',
      phone: selected.phone || '',
      internalPhone: selected.internalPhone || '',
      designation: selected.designation || '',
      joiningDate: selected.joiningDate || '',
      status: selected.status || 'ACTIVE',
    })
    setFormError('')
    setShowForm(true)
  }

  function departmentOptionsForUnit(unitName) {
    const unit = employeeOptions.units.find((item) => item.name === unitName || item.code === unitName)
    return employeeOptions.departments[unit?.code || unitName] || []
  }

  return (
    <section className="employee-page">
      <div className="page-heading">
        <div>
          <div className="section-kicker">◉</div>
          <h2>Employees Management</h2>
          <p>Manage employee profiles, department, training participation and more</p>
        </div>
        <div className="page-actions">
          <button type="button" className="action-primary" onClick={() => setShowForm(true)}>＋ Add Employee</button>
          <button type="button" className="action-secondary" onClick={() => importInput.current?.click()}>↥ Import (Excel)</button>
          <input ref={importInput} type="file" accept=".xlsx,.xls" hidden onChange={handleImport} />
          <button type="button" className="action-secondary" onClick={handleExport}>▣ Export</button>
        </div>
      </div>

      {importMessage && <p className="form-error">{importMessage}</p>}

      {showForm && <div className="employee-modal-backdrop" role="presentation"><form className="employee-modal" onSubmit={submitEmployee}><div className="panel-title"><span className="panel-label">{editingEmployee ? 'Edit Employee' : 'Add Employee'}</span><button type="button" className="close-detail" onClick={() => { setShowForm(false); setEditingEmployee(null) }}>×</button></div><label>Employee ID<input required value={form.employeeId} onChange={(event) => setForm({ ...form, employeeId: event.target.value })} /></label><label>Name<input required value={form.name} onChange={(event) => setForm({ ...form, name: event.target.value })} /></label><div className="employee-modal-row"><label>Unit<select required value={form.unit} onChange={(event) => setForm({ ...form, unit: event.target.value, department: '' })}><option value="">Select unit</option>{employeeOptions.units.map((unit) => <option key={unit.code} value={unit.name}>{unit.name}</option>)}</select></label><label>Department<select required disabled={!form.unit} value={form.department} onChange={(event) => setForm({ ...form, department: event.target.value })}><option value="">Select department</option>{departmentOptionsForUnit(form.unit).map((department) => <option key={department.code} value={department.name}>{department.name}</option>)}</select></label></div><label>Email<input type="email" value={form.email} onChange={(event) => setForm({ ...form, email: event.target.value })} /></label><div className="employee-modal-row"><label>Phone<input value={form.phone} onChange={(event) => setForm({ ...form, phone: event.target.value })} /></label><label>Internal Phone Number<input value={form.internalPhone} onChange={(event) => setForm({ ...form, internalPhone: event.target.value })} /></label></div><label>Designation<input value={form.designation} onChange={(event) => setForm({ ...form, designation: event.target.value })} /></label><div className="employee-modal-row"><label>Joining Date<input type="date" value={form.joiningDate} onChange={(event) => setForm({ ...form, joiningDate: event.target.value })} /></label><label>Status<select value={form.status} onChange={(event) => setForm({ ...form, status: event.target.value })}><option value="ACTIVE">Active</option><option value="ON_LEAVE">On Leave</option><option value="INACTIVE">Inactive</option></select></label></div>{formError && <p className="form-error">{formError}</p>}<button type="submit" className="action-primary">{editingEmployee ? 'Update Employee' : 'Save Employee'}</button></form></div>}

      <div className="employee-stat-grid">
        <EmployeeStat label="Total Employees" value={employees.length} note="From database" tone="blue" />
        <EmployeeStat label="By Department" value={departments.length} note="Departments" tone="navy" />
        <EmployeeStat label="Active Employees" value={activeCount} note="Current records" tone="green" />
        <EmployeeStat label="On Leave" value={leaveCount} note="Current records" tone="red" />
        <EmployeeStat label="New Joinees (This Month)" value="-" note="Not available" tone="orange" />
      </div>

      <div className="employee-filters panel">
        <label>Department<select value={filters.department} onChange={(event) => setFilters({ ...filters, department: event.target.value })}><option value="">All Departments</option>{departments.map((item) => <option key={item}>{item}</option>)}</select></label>
        <label>Unit<select value={filters.unit} onChange={(event) => setFilters({ ...filters, unit: event.target.value })}><option value="">All Units</option>{units.map((item) => <option key={item}>{item}</option>)}</select></label>
        <label>Employment Type<select defaultValue=""><option value="">All Types</option><option>Permanent</option><option>Contract</option></select></label>
        <label>Status<select defaultValue=""><option value="">All Status</option><option>Active</option><option>On Leave</option></select></label>
        <input className="employee-search" placeholder="⌕  Search by name, employee ID, department..." aria-label="Search employees" />
        <button type="button" className="filter-apply">Apply</button>
        <button type="button" className="filter-reset" onClick={() => setFilters({ department: '', unit: '' })}>Reset</button>
      </div>

      <div className={`employee-content-grid${selected ? '' : ' employee-content-grid-empty'}`}>
        <div className="panel employee-list-panel">
          <div className="panel-title"><span className="panel-label">▣ &nbsp; Employee List</span><span className="result-count">Showing {visibleEmployees.length} of {employees.length} employees</span></div>
          <div className="employee-table-wrap">
            <table className="employee-table">
              <thead><tr><th>□</th><th>#</th><th>Employee ID</th><th>Name</th><th>Department</th><th>Unit</th><th>Designation</th><th>Email</th><th>Phone</th><th>Internal Phone</th><th>Status</th><th>Actions</th></tr></thead>
              <tbody>{visibleEmployees.length ? visibleEmployees.map((employee, index) => <tr key={employee.id} onClick={() => setSelected(employee)}><td>□</td><td>{index + 1}</td><td>{employee.employeeId}</td><td><span className="employee-avatar">{employee.name.charAt(0)}</span>{employee.name}</td><td>{employee.department}</td><td>{employee.unit}</td><td>{employee.designation || '-'}</td><td>{employee.email || '-'}</td><td>{employee.phone || '-'}</td><td>{employee.internalPhone || '-'}</td><td><span className={`employee-status ${employee.status === 'On Leave' ? 'leave' : ''}`}>{employee.status || '-'}</span></td><td><span className="row-actions">◉　⌕　▣</span></td></tr>) : <tr><td colSpan="12" className="empty-table">No employees found in the database.</td></tr>}</tbody>
            </table>
          </div>
        </div>

        {selected && <aside className="panel employee-detail-panel">
          <div className="panel-title"><span className="panel-label">♟ &nbsp; Employee Details</span><button type="button" className="close-detail" onClick={() => setSelected(null)}>×</button></div>
          <div className="detail-identity"><div className="detail-avatar">{selected?.name?.charAt(0) || '-'}</div><div><h3>{selected?.name || 'No employee selected'}</h3><p>{selected?.employeeId || '-'}</p><p>{selected ? `${selected.designation || '-'} - ${selected.department || '-'}` : 'Select a database record'}</p>{selected && <span className="employee-status">{selected.status || '-'}</span>}</div></div>
          <div className="detail-tabs"><button type="button" className="active">♟ Profile</button><button type="button">▣ Training History</button><button type="button">◍ Attendance</button></div>
          <dl className="detail-fields">
            <DetailField label="Employee ID" value={selected?.employeeId || '-'} />
            <DetailField label="Name" value={selected?.name || '-'} />
            <DetailField label="Department" value={selected?.department || '-'} />
            <DetailField label="Unit" value={selected?.unit || '-'} />
            <DetailField label="Designation" value={selected?.designation || '-'} />
            <DetailField label="Email" value={selected?.email || '-'} />
            <DetailField label="Internal Phone" value={selected?.internalPhone || '-'} />
          </dl>
          <div className="employee-detail-actions"><button type="button" className="full-profile" onClick={openEditForm} disabled={!selected}>✎ Edit Employee Details</button><button type="button" className="delete-action" onClick={handleDelete} disabled={!selected}>Delete Employee</button></div>
        </aside>}
      </div>

      <div className="employee-bottom-grid"><div className="panel employee-chart"><div className="panel-title"><span className="panel-label">▣ &nbsp; Employee Distribution</span></div><div className="empty-chart">No distribution data available.</div></div><div className="panel employee-chart"><div className="panel-title"><span className="panel-label">▣ &nbsp; Employees by Designation</span></div><div className="empty-chart">No designation data available.</div></div><div className="panel quick-employee-actions"><div className="panel-title"><span className="panel-label">▣ &nbsp; Quick Actions</span></div><button type="button">＋ Add Employee</button><button type="button">↥ Import Employees (Excel)</button><button type="button">▣ Download Employee List</button><button type="button">▤ Generate Employee Report</button><button type="button">◉ View On Leave Employees</button></div></div>
      {confirmDelete && <ConfirmDialog message={`Delete ${selected.name} from the database?`} onCancel={() => setConfirmDelete(false)} onConfirm={confirmEmployeeDelete} />}
    </section>
  )
}

function EmployeeStat({ label, value, note, tone, change }) {
  return <div className={`employee-stat ${tone}`}><span className="employee-stat-icon">●</span><div><span>{label}</span><strong>{value}</strong><small>{note}</small>{change && <b>{change}</b>}</div></div>
}

function DetailField({ label, value }) {
  return <><dt>{label}</dt><dd>{value}</dd></>
}

export default EmployeeManagement