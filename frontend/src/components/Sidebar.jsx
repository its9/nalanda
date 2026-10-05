const navItems = [
  { name: 'Dashboard', icon: '⌂' },
  { name: 'Employees', icon: '👥' },
  { name: 'Programs', icon: '▣' },
  { name: 'Nominations', icon: '📝' },
  { name: 'Attendance', icon: '✓' },
  { name: 'Faculty', icon: '🎓' },
  { name: 'Halls', icon: '🏛' },
  { name: 'Reports', icon: '📊' },
  { name: 'Documents', icon: '📄' },
  { name: 'Feedback', icon: '💬' },
  { name: 'Users & Roles', icon: '👤' },
  { name: 'Backup & Restore', icon: '💾' },
]

function Sidebar({ activeItem = 'Dashboard', onNavigate, expanded, onMouseEnter, onMouseLeave, pinned, onTogglePin }) {
  return (
    <aside className={`sidebar ${expanded ? 'expanded' : 'collapsed'}`} onMouseEnter={onMouseEnter} onMouseLeave={onMouseLeave}>
      <button type="button" className={`menu-toggle sidebar-toggle ${pinned ? 'on' : 'off'}`} onClick={onTogglePin} aria-label={pinned ? 'Turn sidebar pin off' : 'Turn sidebar pin on'} aria-expanded={pinned} title={pinned ? 'Sidebar pinned open' : 'Sidebar hover mode'}>☰</button>
      <nav className="nav-list" aria-label="Sidebar navigation">
        {navItems.map((item, index) => (
          <button key={item.name} className={`nav-item ${item.name === activeItem ? 'active' : ''}`} type="button" title={item.name} aria-label={item.name} onClick={() => onNavigate?.(item.name)}>
            <span className="nav-icon" aria-hidden="true">{item.icon}</span>
            {item.name}
          </button>
        ))}
      </nav>

      <button type="button" className={`nav-item sidebar-settings ${activeItem === 'Settings' ? 'active' : ''}`} title="Settings" aria-label="Settings" onClick={() => onNavigate?.('Settings')}>
        <span className="nav-icon" aria-hidden="true">⚙</span>
        Settings
      </button>
    </aside>
  )
}

export default Sidebar
