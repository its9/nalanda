const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api'

async function request(path) {
  const response = await fetch(`${API_BASE_URL}${path}`)

  if (!response.ok) {
    throw new Error(`API request failed: ${response.status}`)
  }

  return response.json()
}

export function getDashboardData() {
  return Promise.all([
    request('/dashboard/summary'),
    request('/dashboard/programs'),
    request('/dashboard/attendance'),
    request('/dashboard/employees'),
    request('/dashboard/halls'),
    request('/dashboard/faculty'),
    request('/programs'),
  ]).then(([summary, programsChart, attendance, employees, halls, faculty, programs]) => ({
    summary,
    programsChart,
    attendance,
    employees,
    halls,
    faculty,
    programs: programs.items || [],
  }))
}

export async function getEmployees(filters = {}) {
  const query = new URLSearchParams()
  if (filters.department) query.set('department', filters.department)
  if (filters.unit) query.set('unit', filters.unit)
  const suffix = query.toString() ? `?${query.toString()}` : ''
  return request(`/employees${suffix}`)
}

export function getEmployeeOptions() {
  return request('/employees/options')
}

export function getResource(path) {
  return request(path)
}

export function getUsers() { return request('/users') }
export function getRoles() { return request('/roles') }
export function getPermissions() { return request('/permissions') }
export function getRolePermissions(roleId) { return request(`/roles/${roleId}/permissions`) }

export async function updateRolePermissions(roleId, permissions) {
  const response = await fetch(`${API_BASE_URL}/roles/${roleId}/permissions`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ permissions }),
  })
  if (!response.ok) throw new Error(`Permission update failed: ${response.status}`)
  return response.json()
}
export function getEmployeesForUsers() { return request('/employees') }

export async function saveUser(id, user) {
  const response = await fetch(`${API_BASE_URL}/users${id ? `/${id}` : ''}`, {
    method: id ? 'PUT' : 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(user),
  })
  if (!response.ok) throw new Error(`User save failed: ${response.status}`)
  return response.json()
}

export async function deleteUser(id) {
  const response = await fetch(`${API_BASE_URL}/users/${id}`, { method: 'DELETE' })
  if (!response.ok) throw new Error(`User deletion failed: ${response.status}`)
}

export async function userAction(id, action) {
  const response = await fetch(`${API_BASE_URL}/users/${id}/${action}`, { method: 'PUT' })
  if (!response.ok) throw new Error(`User action failed: ${response.status}`)
  return response.json()
}

export async function saveRole(id, role) {
  const response = await fetch(`${API_BASE_URL}/roles${id ? `/${id}` : ''}`, {
    method: id ? 'PUT' : 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(role),
  })
  if (!response.ok) throw new Error(`Role save failed: ${response.status}`)
  return response.json()
}

export async function deleteRole(id) {
  const response = await fetch(`${API_BASE_URL}/roles/${id}`, { method: 'DELETE' })
  if (!response.ok) throw new Error(`Role deletion failed: ${response.status}`)
}

export function getSettings(scope = 'general') {
  return request(`/settings/${encodeURIComponent(scope)}`)
}

export async function updateSettings(scope, values) {
  const response = await fetch(`${API_BASE_URL}/settings/${encodeURIComponent(scope)}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(values),
  })
  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || error.error || `Settings update failed: ${response.status}`)
  }
  return response.json()
}

export function getPrograms() {
  return request('/programs')
}

export function getAttendance(filters = {}) {
  const query = filters.programId ? `?programId=${encodeURIComponent(filters.programId)}` : ''
  return request(`/attendance${query}`)
}

export function getAttendanceSummary(programId) {
  return request(`/attendance/summary/${programId}`)
}

export function getNominatedAttendance(employeeNumber) {
  return request(`/attendance/employee?employeeNumber=${encodeURIComponent(employeeNumber)}`)
}

export function getNominatedProgramAttendance(programId, date) {
  const query = date ? `?date=${encodeURIComponent(date)}` : ''
  return request(`/attendance/program/${encodeURIComponent(programId)}/nominated${query}`)
}

export async function saveAttendance(attendance, id = null) {
  const response = await fetch(`${API_BASE_URL}/attendance${id ? `/${id}` : '/mark'}`, {
    method: id ? 'PUT' : 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(attendance),
  })
  if (!response.ok) throw new Error(`Attendance update failed: ${response.status}`)
  return response.json()
}

export function getDocuments(programId) {
  return request(programId ? `/programs/${programId}/documents` : '/documents')
}

export async function uploadDocument(file, programId, folder) {
  const body = new FormData()
  body.append('file', file)
  if (programId) body.append('programId', programId)
  if (folder) body.append('folder', folder)
  const response = await fetch(`${API_BASE_URL}/documents/upload`, { method: 'POST', body })
  if (!response.ok) throw new Error(`Document upload failed: ${response.status}`)
  return response.json()
}

export async function deleteDocument(id) {
  const response = await fetch(`${API_BASE_URL}/documents/${id}`, { method: 'DELETE' })
  if (!response.ok) throw new Error(`Document deletion failed: ${response.status}`)
}

export function getDocumentDownloadUrl(id) {
  return `${API_BASE_URL}/documents/${id}/download`
}

export function getDocumentPreviewUrl(id) {
  return `${API_BASE_URL}/documents/${id}/download?inline=true`
}

export async function createProgramFolder(programId, name, parent) {
  const query = new URLSearchParams({ name })
  if (parent) query.set('parent', parent)
  const response = await fetch(`${API_BASE_URL}/programs/${programId}/folders?${query}`, { method: 'POST' })
  if (!response.ok) throw new Error(`Folder creation failed: ${response.status}`)
  return response.json()
}

export async function deleteProgramFolder(programId, folder) {
  const query = new URLSearchParams({ path: folder })
  const response = await fetch(`${API_BASE_URL}/programs/${programId}/folders?${query}`, { method: 'DELETE' })
  if (!response.ok) throw new Error(`Folder deletion failed: ${response.status}`)
}

export function getProgramFolders(programId) {
  return request(`/programs/${programId}/folders`)
}

export function searchEmployees(name) {
  return request(`/employees/search?name=${encodeURIComponent(name)}`)
}

export async function createEmployee(employee) {
  const payload = { ...employee, unit: employee.unit || employee.wing }
  delete payload.wing
  const response = await fetch(`${API_BASE_URL}/employees`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })

  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Employee creation failed: ${response.status}`)
  }

  return response.json()
}

export async function updateEmployee(id, employee) {
  const payload = { ...employee, unit: employee.unit || employee.wing }
  delete payload.wing
  const response = await fetch(`${API_BASE_URL}/employees/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })

  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Employee update failed: ${response.status}`)
  }

  return response.json()
}

export async function uploadEmployees(file) {
  const body = new FormData()
  body.append('file', file)
  const response = await fetch(`${API_BASE_URL}/employees/import`, {
    method: 'POST',
    body,
  })

  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Employee import failed: ${response.status}`)
  }

  return response.json()
}

export async function exportEmployees() {
  const response = await fetch(`${API_BASE_URL}/employees/export`)
  if (!response.ok) {
    throw new Error(`Employee export failed: ${response.status}`)
  }
  const blob = await response.blob()
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = 'employees.csv'
  link.click()
  URL.revokeObjectURL(url)
}

export async function deleteEmployee(id) {
  const response = await fetch(`${API_BASE_URL}/employees/${id}`, { method: 'DELETE' })
  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Employee deletion failed: ${response.status}`)
  }
}

export async function createHall(hall, photo) {
  const body = new FormData()
  body.append('name', hall.name)
  body.append('capacity', hall.capacity)
  if (hall.location) body.append('location', hall.location)
  if (hall.facilities?.length) body.append('facilities', Array.isArray(hall.facilities) ? hall.facilities.join(', ') : hall.facilities)
  if (photo) body.append('photo', photo)
  const response = await fetch(`${API_BASE_URL}/halls`, {
    method: 'POST',
    body,
  })
  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Hall creation failed: ${response.status}`)
  }

  return response.json()
}

export async function updateHall(id, hall) {
  if (hall.photo) {
    const body = new FormData()
    body.append('name', hall.name)
    body.append('capacity', String(Number(hall.capacity)))
    body.append('location', hall.location || '')
    body.append('facilities', Array.isArray(hall.facilities) ? hall.facilities.join(', ') : hall.facilities || '')
    body.append('photo', hall.photo)
    const response = await fetch(`${API_BASE_URL}/halls/${id}`, { method: 'PUT', body })
    if (!response.ok) throw new Error(`Hall update failed: ${response.status}`)
    return response.json()
  }
  const response = await fetch(`${API_BASE_URL}/halls/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: hall.name, capacity: Number(hall.capacity), location: hall.location, facilities: Array.isArray(hall.facilities) ? hall.facilities.join(', ') : hall.facilities }),
  })
  if (!response.ok) throw new Error(`Hall update failed: ${response.status}`)
  return response.json()
}

export function getHallPhotoUrl(id) {
  return `${API_BASE_URL}/halls/${id}/photo`
}

async function backupAction(path) {
  const response = await fetch(`${API_BASE_URL}${path}`, { method: 'POST' })
  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Backup action failed: ${response.status}`)
  }
  return response.json()
}

export function createBackup() { return backupAction('/backup/create') }
export function verifyBackup(id) { return backupAction(`/backup/${id}/verify`) }
export function restoreBackup(id) { return backupAction(`/backup/${id}/restore`) }

export function getBackupDrives() { return request('/backup/drives') }
export function getBackupSettings() { return request('/backup/settings') }

export async function updateBackupSettings(settings) {
  const response = await fetch(`${API_BASE_URL}/backup/settings`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(settings),
  })
  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Backup settings update failed: ${response.status}`)
  }
  return response.json()
}

export async function deleteHall(id) {
  const response = await fetch(`${API_BASE_URL}/halls/${id}`, { method: 'DELETE' })
  if (!response.ok) {
    const error = await response.json().catch(() => ({}))
    throw new Error(error.message || `Hall deletion failed: ${response.status}`)
  }
}