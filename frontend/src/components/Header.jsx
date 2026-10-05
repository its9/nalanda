import { useState } from 'react'

function Header({ onSearch, programs = [], organizationName = 'Bharat Electronics Limited (BEL)', wing = 'Quality Wing', logo = '' }) {
  const [query, setQuery] = useState('')
  const [notificationsOpen, setNotificationsOpen] = useState(false)

  function submitSearch(event) {
    event.preventDefault()
    if (query.trim()) onSearch(query.trim())
  }

  const upcomingPrograms = programs
    .filter((program) => program.startDate && new Date(`${program.startDate}T00:00:00`) >= new Date())
    .sort((left, right) => new Date(left.startDate) - new Date(right.startDate))
    .slice(0, 4)

  return (
    <header className="topbar">
      <div className="brand-header">
        <div className="header-badge">{logo ? <img src={logo} alt="" /> : 'BEL'}</div>
        <div>
          <h1>{organizationName}</h1>
          <p>{wing} | Training &amp; Program Management System</p>
        </div>
      </div>

      <div className="topbar-actions">
        <form className="search-box" onSubmit={submitSearch}>
          <span>⌕</span>
          <input value={query} onChange={(event) => setQuery(event.target.value)} type="search" placeholder="Search programs, employees, halls..." aria-label="Search" />
        </form>
        <button type="button" className="notification-btn" onClick={() => setNotificationsOpen((open) => !open)} aria-label="Notifications">◔</button>
        {notificationsOpen && <div className="notification-popover"><strong>Upcoming Programs</strong>{upcomingPrograms.length ? upcomingPrograms.map((program) => <div className="notification-item" key={program.id || program.code}><b>{program.name}</b><small>{program.startDate} · {program.status}</small></div>) : <span>No upcoming programs</span>}</div>}
        <div className="user-pill">
          <span className="user-avatar">A</span>
          <span>Admin</span>
          <small>{wing}</small>
        </div>
      </div>
    </header>
  )
}

export default Header
