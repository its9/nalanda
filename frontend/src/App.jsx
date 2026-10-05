import { useEffect, useState } from 'react'
import './App.css'
import { getDashboardData, getSettings } from './api/dashboardApi'
import EmployeeManagement from './components/EmployeeManagement'
import AttendanceManagement from './components/AttendanceManagement'
import DocumentManagement from './components/DocumentManagement'
import FeedbackManagement from './components/FeedbackManagement'
import Header from './components/Header'
import ProgramsManagement from './components/ProgramsManagement'
import ProgramSettingsPage from './components/ProgramSettingsPage'
import ResourceView from './components/ResourceView'
import Sidebar from './components/Sidebar'
import StatCard from './components/StatCard'
import UsersRolesManagement from './components/UsersRolesManagement'
function App() {
  const [activeView, setActiveView] = useState(() => {
    try {
      return window.localStorage.getItem('nalanda.activeView') || 'Dashboard'
    } catch {
      return 'Dashboard'
    }
  })
  const [dashboard, setDashboard] = useState(null)
  const [apiState, setApiState] = useState('loading')
  const [searchQuery, setSearchQuery] = useState('')
  const [sidebarPinned, setSidebarPinned] = useState(false)
  const [sidebarHovered, setSidebarHovered] = useState(false)
  const [branding, setBranding] = useState({ organizationName: 'Bharat Electronics Limited (BEL)', wing: 'Quality Wing', logo: '' })
  const resourceViews = ['Programs', 'Nominations', 'Attendance', 'Faculty', 'Halls', 'Reports', 'Documents', 'Feedback', 'Users & Roles', 'Backup & Restore', 'Settings']

  function navigateTo(view) {
    setActiveView(view)
    try {
      window.localStorage.setItem('nalanda.activeView', view)
    } catch {
      // The page still navigates when browser storage is unavailable.
    }
  }

  function handleSearch(query) {
    navigateTo('Employees')
    setSearchQuery(query)
    setApiState('loading')
  }

  useEffect(() => {
    getDashboardData()
      .then((data) => {
        setDashboard(data)
        setApiState('connected')
      })
      .catch(() => setApiState('offline'))
  }, [])

  useEffect(() => {
    const loadBranding = () => getSettings('general')
      .then(({ values = {} }) => setBranding((current) => ({ ...current, ...values })))
      .catch(() => {})
    loadBranding()
    const updateBranding = (event) => event.detail && setBranding((current) => ({ ...current, ...event.detail }))
    window.addEventListener('nalanda:general-settings-updated', updateBranding)
    return () => window.removeEventListener('nalanda:general-settings-updated', updateBranding)
  }, [])

  useEffect(() => {
    if (!branding.logo) return
    let favicon = document.querySelector('link[rel="icon"]')
    if (!favicon) {
      favicon = document.createElement('link')
      favicon.rel = 'icon'
      document.head.appendChild(favicon)
    }
    favicon.href = branding.logo
  }, [branding.logo])

  const summary = dashboard?.summary
  const liveStats = [
    { label: 'Total Programs', value: summary?.totalPrograms ?? '-', change: summary ? 'Database' : 'No data', tone: 'blue' },
    { label: 'Attendance', value: summary ? `${summary.averageAttendance}%` : '-', change: summary ? 'Database' : 'No data', tone: 'green' },
    { label: 'Nominations', value: summary?.totalNominations ?? '-', change: summary ? 'Database' : 'No data', tone: 'purple' },
    { label: 'Employees', value: summary?.totalEmployees ?? '-', change: summary ? 'Database' : 'No data', tone: 'orange' },
  ]

  const liveMiniStats = [
    { label: 'Ongoing Programs', value: dashboard?.programsChart?.values?.[1] ?? '-', tone: 'primary' },
    { label: 'Upcoming Programs', value: dashboard?.programsChart?.values?.[2] ?? '-', tone: 'gold' },
    { label: 'Completed Programs', value: dashboard?.programsChart?.values?.[0] ?? '-', tone: 'green' },
    { label: 'Cancelled Programs', value: dashboard?.programsChart?.values?.[3] ?? '-', tone: 'red' },
    { label: 'Active Faculty', value: dashboard?.faculty?.values?.reduce((total, value) => total + value, 0) ?? '-', tone: 'purple' },
  ]

  const programItems = dashboard?.programs?.length
    ? dashboard.programs.slice(0, 4).map((program) => ({
        name: program.name,
        meta: `${program.status} | ${program.unit}`,
      }))
    : []

  return (
    <div className="app-shell">
      <Sidebar activeItem={activeView} onNavigate={navigateTo} expanded={sidebarPinned || sidebarHovered} pinned={sidebarPinned} onTogglePin={() => setSidebarPinned((open) => !open)} onMouseEnter={() => setSidebarHovered(true)} onMouseLeave={() => setSidebarHovered(false)} />

      <main className="main-panel">
        <Header onSearch={handleSearch} programs={dashboard?.programs || []} organizationName={branding.organizationName} wing={branding.wing} logo={branding.logo} menuOpen={sidebarPinned} onMenuToggle={() => setSidebarPinned((open) => !open)} />

        {activeView === 'Employees' ? (
          <EmployeeManagement onApiState={setApiState} searchQuery={searchQuery} />
        ) : activeView === 'Programs' ? (
          <ProgramsManagement onApiState={setApiState} />
        ) : activeView === 'Documents' ? (
          <DocumentManagement />
        ) : activeView === 'Feedback' ? (
          <FeedbackManagement />
        ) : activeView === 'Attendance' ? (
          <AttendanceManagement onApiState={setApiState} />
        ) : activeView === 'Settings' ? (
          <ProgramSettingsPage />
        ) : activeView === 'Users & Roles' ? (
          <UsersRolesManagement />
        ) : resourceViews.includes(activeView) ? (
          <ResourceView resource={activeView} onApiState={setApiState} />
        ) : (
          <>

        <div className="welcome-row">
          <div>
            <h2>Welcome, Admin!</h2>
            <p>Here&apos;s an overview of training and program activities in the {branding.wing}.</p>
          </div>
          <div className="date-box">
            <span>15 September 2026</span>
            <small>Tuesday</small>
          </div>
        </div>

        <section className="stats-grid">
          {liveStats.map((stat) => (
            <StatCard key={stat.label} {...stat} />
          ))}
        </section>

        <section className="mini-grid">
          {liveMiniStats.map((item) => (
            <div key={item.label} className={`mini-card ${item.tone}`}>
              <div className="mini-icon" aria-hidden="true">{item.label.charAt(0)}</div>
              <div className="mini-copy">
                <span>{item.label}</span>
                <strong>{item.value}</strong>
              </div>
            </div>
          ))}
        </section>

        <section className="chart-grid">
          <div className="panel donut-panel">
            <div className="panel-title">
              <span className="panel-label">Program Status</span>
            </div>
            <div className="donut-wrap">
              <div className="donut-chart">
                <div className="donut-inner">
                  <strong>{summary?.totalPrograms ?? '-'}</strong>
                  <span>Programs</span>
                </div>
              </div>
              <ul className="legend">
                {(dashboard?.programsChart?.labels || []).map((label, index) => (
                  <li key={label}><span className={`legend-dot ${['blue', 'teal', 'gold', 'red'][index]}`} /> {label} <strong>{dashboard.programsChart.values[index]}</strong></li>
                ))}
              </ul>
            </div>
          </div>

          <div className="panel chart-panel">
            <div className="panel-title">
              <span className="panel-label">Attendance Trend (Last 6 Months)</span>
            </div>
            <div className="line-chart" aria-label="Attendance trend chart">
              <span style={{ left: '10%', bottom: '52%' }} />
              <span style={{ left: '25%', bottom: '48%' }} />
              <span style={{ left: '40%', bottom: '32%' }} />
              <span style={{ left: '55%', bottom: '20%' }} />
              <span style={{ left: '70%', bottom: '15%' }} />
              <span style={{ left: '86%', bottom: '10%' }} />
            </div>
            <div className="chart-labels">
              <span>Apr</span>
              <span>May</span>
              <span>Jun</span>
              <span>Jul</span>
              <span>Aug</span>
              <span>Sep</span>
            </div>
          </div>

          <div className="panel distribution-panel">
            <div className="panel-title">
              <span className="panel-label">Employee Distribution by Department</span>
            </div>
            <div className="bar-chart">
              {(dashboard?.employees?.labels || []).map((label, index) => <div key={label} className="bar-group"><span className={`bar ${['blue', 'green', 'gold'][index] || 'gray'}`} style={{ height: `${Math.max(0, Number(dashboard.employees.values[index] || 0))}%` }} /><label>{label}</label></div>)}
              <div className="bar-group"><span className="bar purple" style={{ height: '34%' }} /><label>HR</label></div>
              <div className="bar-group"><span className="bar red" style={{ height: '62%' }} /><label>IT</label></div>
              <div className="bar-group"><span className="bar gray" style={{ height: '24%' }} /><label>Safety</label></div>
              <div className="bar-group"><span className="bar pale" style={{ height: '18%' }} /><label>Others</label></div>
            </div>
          </div>
        </section>

        <section className="bottom-grid">
          <div className="panel topic-panel">
            <div className="panel-title">
              <span className="panel-label">Top Training Topics</span>
            </div>
            <ul className="topic-list">
              {(dashboard?.trainingTopics || []).map((item) => (
                <li key={item.name}>
                  <span>{item.name}</span>
                  <div className="topic-progress"><i style={{ width: `${item.value}%` }} className={item.color} /></div>
                  <strong>{item.value}</strong>
                </li>
              ))}
            </ul>
          </div>

          <div className="panel hall-panel">
            <div className="panel-title">
              <span className="panel-label">Halls Utilization</span>
            </div>
            <div className="donut-small">
              <div className="donut-center">
                <strong>{dashboard?.halls?.values?.reduce((total, value) => total + value, 0) ?? '-'}</strong>
                <span>Halls</span>
              </div>
            </div>
            <div className="legend-inline">
              {(dashboard?.halls?.labels || []).map((label, index) => (
                <div key={label} className="legend-inline-item">
                  <span className={`legend-dot ${['green', 'blue'][index]}`} />
                  <span>{label}</span>
                  <strong>{dashboard.halls.values[index]}</strong>
                </div>
              ))}
            </div>
          </div>

          <div className="panel schedule-panel">
            <div className="panel-title schedule-head">
              <span className="panel-label">Upcoming Programs</span>
              <button type="button" onClick={() => setActiveView('Programs')}>View All</button>
            </div>
            <div className="program-list">
              {programItems.map((program, index) => (
                <div key={program.name} className="program-item"><span className="program-day blue">{20 + index}</span> <div><strong>{program.name}</strong><small>{program.meta}</small></div></div>
              ))}
            </div>
          </div>
        </section>

        <section className="bottom-grid lower-grid">
          <div className="panel activity-panel">
            <div className="panel-title">
              <span className="panel-label">Recent Activities</span>
            </div>
            <div className="table-slim">
              <div className="row header">
                <span>Date</span>
                <span>Activity</span>
                <span>Details</span>
                <span>By</span>
              </div>
              <div className="row empty-table"><span>No activity data available.</span></div>
            </div>
          </div>

          <div className="panel quick-panel">
            <div className="panel-title">
              <span className="panel-label">Quick Actions</span>
            </div>
            <div className="quick-actions">
              <button type="button" onClick={() => setActiveView('Programs')}>＋ Add Program</button>
              <button type="button" onClick={() => setActiveView('Employees')}>👥 Add Employee</button>
              <button type="button" onClick={() => setActiveView('Nominations')}>📝 New Nomination</button>
              <button type="button" onClick={() => setActiveView('Reports')}>📊 Generate Report</button>
            </div>
          </div>

          <div className="panel announce-panel">
            <div className="panel-title with-link">
              <span className="panel-label">Announcements</span>
              <button type="button" onClick={() => setActiveView('Reports')}>View All</button>
            </div>
            <p className="empty-table">No announcements available.</p>
          </div>
        </section>

        <footer className="footer-bar">
          <div className="footer-brand"><span className="footer-mark">BEL</span> <span>{branding.wing} Training Management System</span></div>
          <span>Version 1.0.0 | © 2026 BEL | Internal Use Only</span>
        </footer>
          </>
        )}
      </main>
    </div>
  )
}

export default App
