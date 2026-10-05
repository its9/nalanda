import { useEffect, useState } from 'react'
import { createBackup, getBackupDrives, getBackupSettings, restoreBackup, updateBackupSettings, verifyBackup } from '../api/dashboardApi'

function BackupResourceView({ data, error, onReload }) {
  const [message, setMessage] = useState('')
  const [drives, setDrives] = useState([])
  const [backupPath, setBackupPath] = useState('')
  const [automaticBackup, setAutomaticBackup] = useState(false)
  const [frequency, setFrequency] = useState('DAILY')
  const [backupTime, setBackupTime] = useState('23:00')
  const [retentionDays, setRetentionDays] = useState(30)
  const [restoreTarget, setRestoreTarget] = useState(null)
  const rows = data?.items || []

  useEffect(() => {
    Promise.all([getBackupDrives(), getBackupSettings()])
      .then(([availableDrives, settings]) => {
        setDrives(availableDrives)
        setBackupPath(settings.backupPath)
        setAutomaticBackup(settings.automaticBackup)
        setFrequency(settings.frequency)
        setBackupTime(settings.time)
        setRetentionDays(settings.retentionDays)
      })
      .catch(() => setMessage('Unable to load backup paths.'))
  }, [])

  async function run(action, successMessage) {
    setMessage('Working...')
    try {
      const result = await action()
      setMessage(`${successMessage} (${result.status})`)
      onReload()
    } catch (actionError) {
      setMessage(actionError.message)
    }
  }

  async function saveBackupPath() {
    try {
      await updateBackupSettings({ backupPath, automaticBackup, frequency, time: backupTime, retentionDays: Number(retentionDays) })
      setMessage(`Backup path saved: ${backupPath}`)
    } catch (actionError) {
      setMessage(actionError.message)
    }
  }

  return (
    <section className="resource-page backup-resource-page">
      <div className="page-heading"><div><div className="section-kicker">⟲</div><h2>Backup &amp; Restore</h2><p>Secure your data. Recover anytime.</p></div><button type="button" className="action-primary" onClick={() => run(createBackup, 'Backup created')}>▣ Backup Now</button></div>
      {message && <p className="form-error">{message}</p>}
      {error && <p className="empty-table">{error}</p>}
      {!error && !data && <p className="empty-table">Loading backups...</p>}
      <div className="backup-workflow-grid">
        <div className="panel backup-card backup-location-card"><h3>1. Backup Location</h3><label>Select Backup Drive<select value={backupPath} onChange={(event) => setBackupPath(event.target.value)}><option value="">Select a system path</option>{drives.map((drive) => <option key={drive} value={drive}>{drive}</option>)}</select></label><p className="backup-path-display">{backupPath || 'No backup path selected'}</p><button type="button" className="action-secondary" disabled={!backupPath} onClick={saveBackupPath}>Save Location</button></div>
        <div className="panel backup-card backup-settings-card"><h3>2. Automatic Backup Settings</h3><label className="backup-toggle"><input type="checkbox" checked={automaticBackup} onChange={(event) => setAutomaticBackup(event.target.checked)} /> Enable Automatic Backup</label><label>Frequency<select value={frequency} onChange={(event) => setFrequency(event.target.value)}><option value="DAILY">Daily</option><option value="WEEKLY">Weekly</option><option value="MONTHLY">Monthly</option></select></label><label>Time<input type="time" value={backupTime} onChange={(event) => setBackupTime(event.target.value)} /></label><label>Keep backups for<input min="1" type="number" value={retentionDays} onChange={(event) => setRetentionDays(event.target.value)} /></label><button type="button" className="action-primary" disabled={!backupPath} onClick={saveBackupPath}>Save Settings</button></div>
        <div className="panel backup-card backup-manual-card"><h3>3. Manual Backup</h3><p>Click below to create a complete database backup.</p><button type="button" className="action-primary" onClick={() => run(createBackup, 'Backup created')}>▣ Backup Now</button></div>
      </div>
      <div className="panel backup-history-card"><div className="panel-title"><span className="panel-label">5. Backup History</span><span className="result-count">{data?.total ?? rows.length} records</span></div>{!rows.length ? <p className="empty-table">No backups have been created.</p> : <div className="backup-table-panel"><table className="backup-table"><thead><tr><th>ID</th><th>Date &amp; Time</th><th>Path</th><th>Size</th><th>Status</th><th>Actions</th></tr></thead><tbody>{rows.map((backup) => <tr key={backup.id}><td>{backup.id}</td><td>{new Date(backup.createdAt).toLocaleString()}</td><td>{backup.backupPath}</td><td>{backup.sizeBytes} bytes</td><td>{backup.status}</td><td><button type="button" className="action-secondary" onClick={() => run(() => verifyBackup(backup.id), 'Backup verified')}>Verify</button><button type="button" className="action-primary" onClick={() => setRestoreTarget(backup)}>Restore</button></td></tr>)}</tbody></table></div>}</div>
      {restoreTarget && <div className="employee-modal-backdrop" role="presentation"><div className="backup-confirm-modal"><button type="button" className="close-detail" onClick={() => setRestoreTarget(null)}>×</button><h3>Confirm Restore</h3><p>This will restore the database from backup #{restoreTarget.id}.</p><p className="form-error">Current data should be backed up before restoring.</p><div><button type="button" className="action-secondary" onClick={() => setRestoreTarget(null)}>Cancel</button><button type="button" className="delete-action" onClick={() => { setRestoreTarget(null); run(() => restoreBackup(restoreTarget.id), 'Backup restored') }}>Restore Now</button></div></div></div>}
    </section>
  )
}

export default BackupResourceView