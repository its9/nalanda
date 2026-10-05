import { useEffect, useState } from 'react'
import { getResource } from '../api/dashboardApi'
import HallResourceView from './HallResourceView'
import BackupResourceView from './BackupResourceView'
import NominationsManagement from './NominationsManagement'
import FacultyManagement from './FacultyManagement'

const resourceLabels = {
  Programs: '/programs',
  Nominations: '/nominations',
  Attendance: '/attendance',
  Faculty: '/faculty',
  Halls: '/halls',
  Reports: '/reports',
  Documents: '/documents',
  Feedback: '/feedback',
  'Users & Roles': '/users',
  'Backup & Restore': '/backup',
  Settings: '/settings',
}

function ResourceView({ resource, onApiState }) {
  const [data, setData] = useState(null)
  const [error, setError] = useState('')

  useEffect(() => {
    setData(null)
    setError('')
    getResource(resourceLabels[resource])
      .then((response) => {
        setData(response)
        onApiState('connected')
      })
      .catch(() => {
        setError('Unable to load this module from the database.')
        onApiState('offline')
      })
  }, [resource, onApiState])

  function reload() {
    getResource(resourceLabels[resource])
      .then((response) => {
        setData(response)
        setError('')
        onApiState('connected')
      })
      .catch(() => {
        setError('Unable to load this module from the database.')
        onApiState('offline')
      })
  }

  const rows = Array.isArray(data) ? data : data?.items || []
  const columns = rows.length && typeof rows[0] === 'object' ? Object.keys(rows[0]) : []

  if (resource === 'Halls') {
    return <HallResourceView data={data} error={error} onReload={reload} />
  }
  if (resource === 'Backup & Restore') {
    return <BackupResourceView data={data} error={error} onReload={reload} />
  }
  if (resource === 'Nominations') {
    return <NominationsManagement data={data} error={error} />
  }
  if (resource === 'Faculty') {
    return <FacultyManagement data={data} error={error} onReload={reload} />
  }

  return (
    <section className="resource-page">
      <div className="page-heading">
        <div>
          <div className="section-kicker">▣</div>
          <h2>{resource}</h2>
          <p>Records loaded from the database</p>
        </div>
      </div>
      <div className="resource-summary panel">
        <strong>{data?.total ?? rows.length}</strong>
        <span>records returned</span>
      </div>
      <div className="panel resource-table-panel">
        {error && <p className="empty-table">{error}</p>}
        {!error && !data && <p className="empty-table">Loading records...</p>}
        {!error && data && !rows.length && <p className="empty-table">No records found in the database.</p>}
        {!!rows.length && <div className="employee-table-wrap"><table className="employee-table"><thead><tr>{columns.map((column) => <th key={column}>{column}</th>)}</tr></thead><tbody>{rows.map((row, index) => <tr key={row.id || index}>{columns.map((column) => <td key={column}>{String(row[column] ?? '-')}</td>)}</tr>)}</tbody></table></div>}
      </div>
    </section>
  )
}

export default ResourceView