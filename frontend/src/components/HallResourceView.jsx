import { useEffect, useMemo, useState } from 'react'
import { createHall, deleteHall, getHallPhotoUrl, getResource, updateHall } from '../api/dashboardApi'
import ConfirmDialog from './ConfirmDialog'

const hallPhotos = {
  Kaveri: 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1000&q=80',
  Thangabhadra: 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=1000&q=80',
}
const facilityOptions = ['Projector', 'AC', 'Whiteboard', 'Sound System', 'Video Conference', 'Wi-Fi', 'Computers', 'TV Screen']

function HallResourceView({ data, error, onReload }) {
  const [selectedHall, setSelectedHall] = useState(null)
  const [showForm, setShowForm] = useState(false)
  const [editing, setEditing] = useState(null)
  const [form, setForm] = useState({ name: '', capacity: '', location: '', facilities: [], photo: null })
  const [message, setMessage] = useState('')
  const [confirmDelete, setConfirmDelete] = useState(null)
  const [query, setQuery] = useState('')
  const [programs, setPrograms] = useState([])
  const rows = data?.items || []
  const visibleRows = useMemo(() => rows.filter((hall) =>
    `${hall.name} ${hall.location || ''}`.toLowerCase().includes(query.toLowerCase())), [rows, query])
  const totalCapacity = rows.reduce((total, hall) => total + Number(hall.capacity || 0), 0)
  const today = new Date().toISOString().slice(0, 10)
  const upcomingBookings = useMemo(() => programs
    .filter((program) => program.hall && program.endDate >= today && ['SCHEDULED', 'ONGOING'].includes(program.status))
    .sort((first, second) => first.startDate.localeCompare(second.startDate)), [programs, today])

  useEffect(() => {
    getResource('/programs').then((response) => setPrograms(response.items || [])).catch(() => setPrograms([]))
  }, [])

  async function submitHall(event) {
    event.preventDefault()
    setMessage('')
    try {
      if (editing) await updateHall(editing.id, form)
      else await createHall({ ...form, capacity: Number(form.capacity) }, form.photo)
      setForm({ name: '', capacity: '', location: '', facilities: [], photo: null })
      setShowForm(false)
      setEditing(null)
      setMessage(editing ? 'Hall updated in the database.' : 'Hall added to the database.')
      onReload()
    } catch (submitError) { setMessage(submitError.message) }
  }

  async function confirmHallDelete() {
    try {
      await deleteHall(confirmDelete.id)
      if (selectedHall?.id === confirmDelete.id) setSelectedHall(null)
      setMessage('Hall deleted from the database.')
      setConfirmDelete(null)
      onReload()
    } catch (deleteError) { setMessage(deleteError.message) }
  }

  const photoFor = (hall) => hall.photoUrl ? getHallPhotoUrl(hall.id) : (hallPhotos[hall.name] || hallPhotos.Kaveri)

  return (
    <section className="resource-page hall-resource-page">
      <div className="page-heading hall-heading">
        <div><div className="section-kicker">▣</div><h2>Halls Management</h2><p>Manage training halls, rooms and facilities</p></div>
        <button type="button" className="action-primary" onClick={() => { setEditing(null); setForm({ name: '', capacity: '', location: '', facilities: [], photo: null }); setShowForm(true) }}>＋ Add Hall</button>
      </div>

      <div className="hall-stat-grid">
        <HallStat icon="▣" label="Total Halls" value={data?.total ?? rows.length} note="From database" />
        <HallStat icon="♟" label="Total Capacity" value={totalCapacity.toLocaleString()} note="Seats available" />
        <HallStat icon="▦" label="Bookings This Month" value="-" note="Booking data unavailable" />
        <HallStat icon="◕" label="Occupancy Rate" value="-" note="Booking data unavailable" />
      </div>

      {message && <p className="form-error">{message}</p>}
      <div className="hall-tabs"><button type="button" className="active">▣ Hall List</button><button type="button">▦ Calendar View</button><button type="button">▥ Utilization Report</button><input value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Search halls by name, location..." /></div>

      <div className="hall-main-grid">
        <div className="panel hall-table-panel">
          <table className="hall-table"><thead><tr><th>#</th><th>Hall Name</th><th>Location</th><th>Capacity</th><th>Facilities</th><th>Status</th></tr></thead><tbody>
            {visibleRows.map((hall, index) => <tr key={hall.id}><td>{index + 1}</td><td><button type="button" className="hall-name-cell" onClick={() => setSelectedHall(hall)}><img src={photoFor(hall)} alt="" /><span><b>{hall.name}</b><small>{hall.location || 'Location not set'}</small></span></button></td><td>{hall.location || '-'}</td><td>{hall.capacity}</td><td><div className="hall-facility-list">{String(hall.facilities || '').split(',').map((facility) => facility.trim()).filter(Boolean).map((facility) => <span key={facility}>{facility}</span>)}</div></td><td><span className={`hall-status ${hall.status === 'MAINTENANCE' ? 'maintenance' : ''}`}>{hall.status || 'AVAILABLE'}</span></td></tr>)}
            {!visibleRows.length && <tr><td colSpan="6" className="empty-table">{error || 'No halls found in the database.'}</td></tr>}
          </tbody></table>
          <div className="hall-table-footer">Showing {visibleRows.length} of {rows.length} halls</div>
        </div>
        {selectedHall ? <aside className="panel hall-details-panel"><div className="panel-title"><span className="panel-label">Hall Details</span><button type="button" className="close-detail" onClick={() => setSelectedHall(null)}>×</button></div><img className="hall-detail-image" src={photoFor(selectedHall)} alt={`${selectedHall.name} hall`} /><h3>{selectedHall.name}</h3><dl><dt>Location</dt><dd>{selectedHall.location || '-'}</dd><dt>Capacity</dt><dd>{selectedHall.capacity}</dd><dt>Facilities</dt><dd><div className="hall-detail-facilities">{String(selectedHall.facilities || '').split(',').map((facility) => facility.trim()).filter(Boolean).map((facility) => <span key={facility}>{facility}</span>)}</div></dd><dt>Status</dt><dd><span className="hall-status">{selectedHall.status || 'AVAILABLE'}</span></dd></dl><div className="hall-detail-actions"><button type="button" className="action-primary hall-detail-button" onClick={() => { setEditing(selectedHall); setForm({ name: selectedHall.name, capacity: selectedHall.capacity, location: selectedHall.location || '', facilities: String(selectedHall.facilities || '').split(',').map((item) => item.trim()).filter(Boolean), photo: null }); setShowForm(true) }}>✎ Edit Hall</button><button type="button" className="hall-remove-button" onClick={() => setConfirmDelete(selectedHall)}>Remove Hall</button></div></aside> : <aside className="panel hall-details-panel hall-empty-details"><h3>Hall Details</h3><p>Select a hall to view its details.</p></aside>}
      </div>

      <div className="hall-lower-grid"><div className="panel"><div className="panel-title"><span className="panel-label">▣ Upcoming Bookings</span><span className="result-count">{upcomingBookings.length} bookings</span></div>{upcomingBookings.length ? <div className="hall-upcoming-bookings">{upcomingBookings.map((program) => <div className="hall-upcoming-booking" key={program.id}><div><b>{program.name}</b><small>{program.hall} · {program.status}</small></div><span>{program.startDate} - {program.endDate || program.startDate}</span></div>)}</div> : <p className="hall-empty-note">No upcoming or active hall bookings found.</p>}</div><div className="panel"><div className="panel-title"><span className="panel-label">▥ Hall Utilization</span></div><div className="hall-bars">{rows.slice(0, 5).map((hall) => <div key={hall.id}><span>{hall.name}</span><i><b style={{ width: '0%' }} /></i><em>-%</em></div>)}</div></div></div>

      {showForm && <div className="employee-modal-backdrop" role="presentation"><form className="employee-modal" onSubmit={submitHall}><div className="panel-title"><span className="panel-label">{editing ? 'Edit Hall' : 'Add Hall'}</span><button type="button" className="close-detail" onClick={() => { setShowForm(false); setEditing(null) }}>×</button></div><label>Hall Name<input required value={form.name} onChange={(event) => setForm({ ...form, name: event.target.value })} /></label><label>Capacity<input required min="1" type="number" value={form.capacity} onChange={(event) => setForm({ ...form, capacity: event.target.value })} /></label><label>Location<select required value={form.location} onChange={(event) => setForm({ ...form, location: event.target.value })}><option value="">Select location</option><option value="Ground Floor">Ground Floor</option><option value="1st Floor">1st Floor</option></select></label><fieldset className="facility-checkboxes"><legend>Facilities</legend>{facilityOptions.map((facility) => <label key={facility}><input type="checkbox" checked={form.facilities.includes(facility)} onChange={(event) => setForm({ ...form, facilities: event.target.checked ? [...form.facilities, facility] : form.facilities.filter((item) => item !== facility) })} />{facility}</label>)}</fieldset><label>{editing ? 'Change Hall Photo' : 'Hall Photo'}<input type="file" accept="image/*" onChange={(event) => setForm({ ...form, photo: event.target.files?.[0] || null })} /></label><button type="submit" className="action-primary">Save Hall</button></form></div>}
      {confirmDelete && <ConfirmDialog title="Remove Hall" message={`Remove "${confirmDelete.name}" from the database? This cannot be undone.`} confirmLabel="Remove" onCancel={() => setConfirmDelete(null)} onConfirm={confirmHallDelete} />}
    </section>
  )
}

function HallStat({ icon, label, value, note }) {
  return <div className="hall-stat-card"><span className="hall-stat-icon">{icon}</span><div><small>{label}</small><strong>{value}</strong><em>{note}</em></div></div>
}

export default HallResourceView
