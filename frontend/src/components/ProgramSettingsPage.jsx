import { useEffect, useMemo, useState } from 'react'
import { getSettings, updateSettings } from '../api/dashboardApi'

const initialCategories = [
  { id: 1, name: 'Technical', description: 'Technical skill development', status: 'Active' },
  { id: 2, name: 'Safety', description: 'Safety and compliance training', status: 'Active' },
  { id: 3, name: 'Leadership', description: 'Leadership and management', status: 'Active' },
  { id: 4, name: 'Behavioural', description: 'Soft skills and behavioural training', status: 'Active' },
  { id: 5, name: 'Domain Specific', description: 'Domain specific knowledge', status: 'Active' },
  { id: 6, name: 'Mandatory', description: 'Mandatory training programs', status: 'Active' },
]

const initialTypes = [
  { id: 1, type: 'Workshop', description: 'Hands-on training', status: 'Active' },
  { id: 2, type: 'Seminar', description: 'Knowledge sharing session', status: 'Active' },
  { id: 3, type: 'Training', description: 'Regular training program', status: 'Active' },
  { id: 4, type: 'Awareness', description: 'Awareness programs', status: 'Active' },
  { id: 5, type: 'Certification', description: 'Certification program', status: 'Active' },
  { id: 6, type: 'Orientation', description: 'New joiner orientation', status: 'Active' },
]

const initialRules = {
  requireNominationApproval: true,
  limitParticipants: true,
  allowWaitlist: false,
  allowExternalParticipants: false,
  autoCloseNominations: true,
  minimumParticipants: 5,
  maximumParticipants: 100,
}

const initialDefaults = {
  durationDays: 1,
  startTime: '09:00',
  endTime: '17:00',
  hall: '',
  category: '',
  type: '',
}

const initialCodeFormat = {
  prefix: 'TRG',
  categoryCode: 'TECH',
  year: new Date().getFullYear(),
  sequenceLength: 3,
}

const initialStatuses = ['Planned', 'Ongoing', 'Completed', 'Cancelled', 'Postponed']

function download(path, filename) {
  const link = document.createElement('a')
  link.href = `${import.meta.env.VITE_API_URL || 'http://localhost:8080/api'}${path}`
  link.download = filename
  link.click()
}

function ProgramSettingsPage() {
  const [activeTab, setActiveTab] = useState('Program Settings')
  const [categories, setCategories] = useState(initialCategories)
  const [types, setTypes] = useState(initialTypes)
  const [rules, setRules] = useState(initialRules)
  const [defaults, setDefaults] = useState(initialDefaults)
  const [codeFormat, setCodeFormat] = useState(initialCodeFormat)
  const [statuses, setStatuses] = useState(initialStatuses)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState('')
  const [message, setMessage] = useState('')
  const [error, setError] = useState('')

  useEffect(() => {
    getSettings('program')
      .then(({ values = {} }) => {
        setCategories(values.categories || initialCategories)
        setTypes(values.types || initialTypes)
        setRules({ ...initialRules, ...(values.rules || {}) })
        setDefaults({ ...initialDefaults, ...(values.defaults || {}) })
        setCodeFormat({ ...initialCodeFormat, ...(values.codeFormat || {}) })
        setStatuses(values.statuses || initialStatuses)
      })
      .catch((requestError) => setError(requestError.message))
      .finally(() => setLoading(false))
  }, [])

  const save = async (section, values) => {
    setSaving(section)
    setMessage('')
    setError('')
    try {
      await updateSettings('program', values)
      setMessage(`${section} saved successfully.`)
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setSaving('')
    }
  }

  const persist = (changes, section) => save(section, { categories, types, rules, defaults, codeFormat, statuses, ...changes })

  const addCategory = () => {
    const name = window.prompt('Category name')
    if (!name?.trim()) return
    const description = window.prompt('Category description') || ''
    const next = [...categories, { id: Date.now(), name: name.trim(), description, status: 'Active' }]
    setCategories(next)
    persist({ categories: next }, 'Category')
  }

  const editCategory = (row) => {
    const name = window.prompt('Category name', row.name)
    if (!name?.trim()) return
    const description = window.prompt('Category description', row.description) || ''
    const next = categories.map((item) => item.id === row.id ? { ...item, name: name.trim(), description } : item)
    setCategories(next)
    persist({ categories: next }, 'Category')
  }

  const deleteCategory = (id) => {
    if (!window.confirm('Delete this category?')) return
    const next = categories.filter((item) => item.id !== id)
    setCategories(next)
    persist({ categories: next }, 'Category')
  }

  const addType = () => {
    const type = window.prompt('Program type')
    if (!type?.trim()) return
    const description = window.prompt('Program type description') || ''
    const next = [...types, { id: Date.now(), type: type.trim(), description, status: 'Active' }]
    setTypes(next)
    persist({ types: next }, 'Program type')
  }

  const editType = (row) => {
    const type = window.prompt('Program type', row.type)
    if (!type?.trim()) return
    const description = window.prompt('Program type description', row.description) || ''
    const next = types.map((item) => item.id === row.id ? { ...item, type: type.trim(), description } : item)
    setTypes(next)
    persist({ types: next }, 'Program type')
  }

  const deleteType = (id) => {
    if (!window.confirm('Delete this program type?')) return
    const next = types.filter((item) => item.id !== id)
    setTypes(next)
    persist({ types: next }, 'Program type')
  }

  const preview = useMemo(() => `${codeFormat.prefix}-${codeFormat.categoryCode}-${codeFormat.year}-${'1'.padStart(Number(codeFormat.sequenceLength) || 1, '0')}`, [codeFormat])

  if (loading) return <section className="program-settings-page"><p className="empty-table">Loading settings from the database...</p></section>

  return (
    <section className="program-settings-page">
      <div className="settings-page-header">
        <div className="settings-title-wrap"><div className="settings-icon">⚙</div><div><h2>Program Settings</h2><p>Configure program categories, default values, approval workflow and other program related settings.</p></div></div>
        <div className="settings-breadcrumb">Settings {'>'} Program Settings</div>
      </div>
      <nav className="settings-tabs" aria-label="Program settings tabs">
        {['General', 'Program Settings', 'Nomination Settings', 'Attendance Settings', 'Hall Settings', 'Approval Workflow', 'Notifications'].map((tab) => <button key={tab} type="button" className={`settings-tab ${tab === activeTab ? 'active' : ''}`} onClick={() => setActiveTab(tab)}>{tab}</button>)}
      </nav>
      {activeTab !== 'Program Settings' && <SettingsSection tab={activeTab} />}
      {activeTab === 'Program Settings' && <>
      {message && <p className="settings-feedback success-message">{message}</p>}
      {error && <p className="settings-feedback error-message">{error}</p>}

      <div className="settings-top-grid">
        <SettingsTable title="Program Categories" addLabel="Add Category" rows={categories} nameKey="name" onAdd={addCategory} onEdit={editCategory} onDelete={deleteCategory} />
        <SettingsTable title="Program Types" addLabel="Add Program Type" rows={types} nameKey="type" onAdd={addType} onEdit={editType} onDelete={deleteType} />
      </div>

      <div className="settings-bottom-grid">
        <div className="settings-card settings-form-card">
          <div className="card-header"><h3>Default Program Settings</h3></div>
          <div className="field-grid">
            <Field label="Default Duration (Days)" type="number" value={defaults.durationDays} onChange={(value) => setDefaults({ ...defaults, durationDays: Number(value) })} />
            <Field label="Default Start Time" type="time" value={defaults.startTime} onChange={(value) => setDefaults({ ...defaults, startTime: value })} />
            <Field label="Default End Time" type="time" value={defaults.endTime} onChange={(value) => setDefaults({ ...defaults, endTime: value })} />
            <Field label="Default Hall" value={defaults.hall} onChange={(value) => setDefaults({ ...defaults, hall: value })} placeholder="Select Hall" />
            <Field label="Default Program Category" value={defaults.category} onChange={(value) => setDefaults({ ...defaults, category: value })} placeholder="Select Category" />
            <Field label="Default Program Type" value={defaults.type} onChange={(value) => setDefaults({ ...defaults, type: value })} placeholder="Select Type" />
          </div>
          <button type="button" className="primary-btn wide-btn" disabled={saving === 'Default settings'} onClick={() => persist({ defaults }, 'Default settings')}>{saving === 'Default settings' ? 'Saving...' : 'Save Default Settings'}</button>
        </div>

        <div className="settings-card settings-form-card">
          <div className="card-header"><h3>Program Rules</h3></div>
          <div className="rule-list">
            {[['requireNominationApproval', 'Require nomination approval'], ['limitParticipants', 'Limit participants per program'], ['allowWaitlist', 'Allow waitlist'], ['allowExternalParticipants', 'Allow external participants'], ['autoCloseNominations', 'Auto-close nominations']].map(([key, label]) => <button type="button" className="rule-toggle" key={key} onClick={() => setRules({ ...rules, [key]: !rules[key] })}><span>{label}</span><span className={`toggle ${rules[key] ? 'on' : ''}`}><span className="toggle-knob" /></span></button>)}
            <div className="rule-numbers"><Field label="Minimum Participants" type="number" value={rules.minimumParticipants} onChange={(value) => setRules({ ...rules, minimumParticipants: Number(value) })} /><Field label="Maximum Participants" type="number" value={rules.maximumParticipants} onChange={(value) => setRules({ ...rules, maximumParticipants: Number(value) })} /></div>
          </div>
          <button type="button" className="primary-btn wide-btn" disabled={saving === 'Rules'} onClick={() => persist({ rules }, 'Rules')}>{saving === 'Rules' ? 'Saving...' : 'Save Rules'}</button>
        </div>

        <div className="settings-card settings-form-card code-card">
          <div className="card-header"><h3>Program Code Format</h3></div>
          <div className="code-format-body">
            <label><span>Code Preview</span><div className="preview-box">{preview}</div></label>
            <div className="format-row"><Field label="Prefix" value={codeFormat.prefix} onChange={(value) => setCodeFormat({ ...codeFormat, prefix: value.toUpperCase() })} /><Field label="Category Code" value={codeFormat.categoryCode} onChange={(value) => setCodeFormat({ ...codeFormat, categoryCode: value.toUpperCase() })} /></div>
            <div className="format-row"><Field label="Year" type="number" value={codeFormat.year} onChange={(value) => setCodeFormat({ ...codeFormat, year: Number(value) })} /><Field label="Sequence Length" type="number" value={codeFormat.sequenceLength} onChange={(value) => setCodeFormat({ ...codeFormat, sequenceLength: Number(value) })} /></div>
            <div className="code-note">Program code will be generated automatically using the saved format.</div>
          </div>
          <button type="button" className="primary-btn wide-btn" disabled={saving === 'Code format'} onClick={() => persist({ codeFormat }, 'Code format')}>{saving === 'Code format' ? 'Saving...' : 'Save Format'}</button>
        </div>
      </div>

      <div className="settings-status-grid">
        <div className="settings-card compact-card">
          <div className="card-header"><h3>Program Status</h3></div>
          <div className="status-buttons">{statuses.map((status) => <button key={status} type="button" className={`status-chip ${status.toLowerCase()}`} onClick={() => window.alert(`${status} is an available program status.`)}>{status}</button>)}</div>
          <button type="button" className="secondary-btn" onClick={() => { const status = window.prompt('New status name'); if (status?.trim() && !statuses.includes(status.trim())) { const next = [...statuses, status.trim()]; setStatuses(next); persist({ statuses: next }, 'Statuses') } }}>Manage Statuses</button>
        </div>
        <div className="settings-card compact-card">
          <div className="card-header"><h3>Bulk Actions</h3></div>
          <div className="bulk-actions">
            <button type="button" className="action-button" onClick={() => document.getElementById('program-settings-import').click()}>Import Programs (Excel)</button>
            <button type="button" className="action-button" onClick={() => download('/export/programs', 'programs.csv')}>Export Programs (Excel)</button>
            <button type="button" className="action-button" onClick={() => download('/templates/programs', 'programs-template.csv')}>Download Template</button>
            <input id="program-settings-import" hidden type="file" accept=".csv,.xlsx,.xls" onChange={async (event) => { const file = event.target.files?.[0]; if (!file) return; const body = new FormData(); body.append('file', file); const response = await fetch(`${import.meta.env.VITE_API_URL || 'http://localhost:8080/api'}/import/programs`, { method: 'POST', body }); if (!response.ok) setError(`Import failed: ${response.status}`); else setMessage('Programs imported successfully.'); event.target.value = '' }} />
          </div>
        </div>
      </div>
      </>}
    </section>
  )
}

const sectionDefaults = {
  General: {
    title: 'General Settings',
    description: 'Basic system configuration and default values.',
    fields: [
      ['organizationName', 'Organization Name', 'Bharat Electronics Limited (BEL)'],
      ['wing', 'Wing / Department', 'Quality Wing'],
      ['academicYear', 'Academic / Calendar Year', '2026'],
      ['timeFormat', 'Time Format', '24 Hour (HH:MM)'],
      ['recordsPerPage', 'Records Per Page', '10'],
    ],
  },
  'Nomination Settings': {
    title: 'Nomination Settings',
    description: 'Configure nomination process and participant limits.',
    fields: [
      ['requireApproval', 'Require Approval for Nominations', true],
      ['allowInternal', 'Allow Internal Participants', true],
      ['allowExternal', 'Allow External Participants', true],
      ['allowWaitlist', 'Allow Waitlist', false],
      ['allowMultiple', 'Allow Multiple Nominations per User', true],
      ['minimumParticipants', 'Minimum Participants per Program', 5],
      ['maximumParticipants', 'Maximum Participants per Program', 100],
      ['startDays', 'Nomination Start Days Before Program', 30],
      ['endDays', 'Nomination End Days Before Program', 3],
      ['defaultStatus', 'Default Nomination Status', 'Pending'],
    ],
  },
  'Attendance Settings': {
    title: 'Attendance Settings',
    description: 'Configure attendance rules and calculations.',
    fields: [
      ['mandatory', 'Mandatory Attendance', true],
      ['minimumCompletion', 'Minimum Attendance % for Completion', 75],
      ['partialDay', 'Allow Partial Day Attendance', true],
      ['markingMethod', 'Attendance Marking Method', 'Manual + Bulk Upload'],
      ['allowEarlyMark', 'Allow Faculty to Mark Attendance', false],
      ['selfAttendance', 'Allow Self Attendance (Employee)', false],
      ['gracePeriod', 'Grace Period (Minutes)', 15],
      ['defaultStatus', 'Default Attendance Status', 'Present'],
    ],
  },
  'Hall Settings': {
    title: 'Hall Settings',
    description: 'Configure hall details, booking rules and availability.',
    fields: [
      ['availableHalls', 'Halls Available', 'Kavere (25), Thangabhadra (60)'],
      ['checkAvailability', 'Check Hall Availability', true],
      ['bufferMinutes', 'Buffer Time Between Programs', 30],
      ['allowOverlap', 'Allow Overlapping Bookings', false],
      ['advanceBooking', 'Advance Booking (Days)', 90],
      ['defaultSetup', 'Default Setup Time (Minutes)', 30],
      ['defaultCleanup', 'Default Cleanup Time (Minutes)', 30],
    ],
  },
  'Approval Workflow': {
    title: 'Approval Workflow',
    description: 'Configure multi-level approval for programs and nominations.',
    fields: [
      ['programApproval', 'Enable Program Approval', true],
      ['nominationApproval', 'Enable Nomination Approval', true],
      ['autoApproveDays', 'Auto Approve if No Action (Days)', 3],
      ['sendApprovalNotification', 'Send Notification on Approval', true],
    ],
  },
  Notifications: {
    title: 'Notification Settings',
    description: 'Configure email and in-app notifications.',
    fields: [
      ['newProgram', 'New Program Created', true],
      ['programApproval', 'Program Approval', true],
      ['newNomination', 'New Nomination', true],
      ['nominationDecision', 'Nomination Approval / Rejection', true],
      ['attendanceReminder', 'Attendance Reminder', true],
      ['programReminder', 'Program Reminder (Before Start)', true],
      ['programCompletion', 'Program Completion', true],
      ['feedbackRequest', 'Feedback Request', true],
      ['hallConfirmation', 'Hall Booking Confirmation', true],
      ['systemAlerts', 'System Alerts (Backup, Errors)', true],
    ],
  },
}

function SettingsSection({ tab }) {
  const config = sectionDefaults[tab]
  const [values, setValues] = useState(Object.fromEntries(config.fields))
  const [saved, setSaved] = useState(false)
  const [saving, setSaving] = useState(false)

  useEffect(() => {
    getSettings(tab.toLowerCase().replaceAll(' ', '-'))
      .then(({ values: stored = {} }) => setValues((current) => ({ ...current, ...stored })))
      .catch(() => {})
  }, [tab])

  const update = (key, value) => setValues((current) => ({ ...current, [key]: value }))
  const selectLogo = (event) => {
    const file = event.target.files?.[0]
    if (!file) return
    if (!file.type.startsWith('image/')) {
      window.alert('Please select an image file.')
      return
    }
    if (file.size > 1024 * 1024) {
      window.alert('Please select an image smaller than 1 MB.')
      return
    }
    const reader = new FileReader()
    reader.onload = () => update('logo', reader.result)
    reader.readAsDataURL(file)
  }
  const save = async () => {
    setSaving(true)
    setSaved(false)
    try {
      await updateSettings(tab.toLowerCase().replaceAll(' ', '-'), values)
      setSaved(true)
      if (tab === 'General') {
        window.dispatchEvent(new CustomEvent('nalanda:general-settings-updated', { detail: values }))
      }
    } catch (requestError) {
      window.alert(requestError.message)
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className={`settings-section-grid ${tab === 'General' ? 'general-section-grid' : ''}`}>
      <div className="settings-card settings-section-card">
        <div className="card-header"><h3>{config.title}</h3></div>
        <p className="settings-section-description">{config.description}</p>
        {tab === 'General' && <div className="branding-upload">
          <div className="branding-preview">{values.logo ? <img src={values.logo} alt="Selected organization logo" /> : <span>BEL</span>}</div>
          <div><strong>Organization Logo &amp; Favicon</strong><p>Upload an image to use in the application header, sidebar and browser tab.</p><input type="file" accept="image/png,image/jpeg,image/svg+xml,image/webp" onChange={selectLogo} /></div>
        </div>}
        <div className="settings-section-fields">
          {config.fields.map(([key, label, defaultValue]) => (
            typeof defaultValue === 'boolean'
              ? <button type="button" className="rule-toggle" key={key} onClick={() => update(key, !values[key])}><span>{label}</span><span className={`toggle ${values[key] ? 'on' : ''}`}><span className="toggle-knob" /></span></button>
              : key === 'academicYear'
                ? <SelectField key={key} label={label} value={values[key]} onChange={(value) => update(key, value)} options={yearOptions()} />
                : key === 'timeFormat'
                  ? <SelectField key={key} label={label} value={values[key]} onChange={(value) => update(key, value)} options={['12 Hour (hh:mm AM/PM)', '24 Hour (HH:MM)']} />
              : <Field key={key} label={label} value={values[key]} onChange={(value) => update(key, value)} />
          ))}
        </div>
        <button type="button" className="primary-btn wide-btn" onClick={save} disabled={saving}>{saving ? 'Saving...' : 'Save Changes'}</button>
        {saved && <p className="settings-saved">Saved successfully.</p>}
      </div>
      {tab === 'Approval Workflow' && <div className="settings-card settings-section-card"><div className="card-header"><h3>Approval Levels</h3><button type="button" className="primary-small-btn" onClick={() => window.alert('Approval level added. Configure the new level in the workflow settings.')}>+ Add Level</button></div><div className="approval-level"><span>1</span><input defaultValue="Program Coordinator" /><button type="button" className="icon-btn delete" onClick={(event) => event.currentTarget.parentElement.remove()}>🗑</button></div><div className="approval-level"><span>2</span><input defaultValue="Admin - Quality Wing" /><button type="button" className="icon-btn delete" onClick={(event) => event.currentTarget.parentElement.remove()}>🗑</button></div></div>}
      {tab === 'Notifications' && <div className="settings-card settings-section-card"><div className="card-header"><h3>Notification Channels</h3></div><div className="channel-choice"><label><input type="checkbox" defaultChecked /> Email Notifications</label><label><input type="checkbox" defaultChecked /> In-App Notifications</label></div><p className="settings-section-description">Notification preferences are stored with the notification settings above.</p></div>}
    </div>
  )
}

function yearOptions() {
  const currentYear = new Date().getFullYear()
  return Array.from({ length: 7 }, (_, index) => String(currentYear - 2 + index))
}

function SelectField({ label, value, onChange, options }) {
  return <label><span>{label}</span><select value={value ?? ''} onChange={(event) => onChange(event.target.value)}>{options.map((option) => <option key={option} value={option}>{option}</option>)}</select></label>
}

function Field({ label, type = 'text', value, onChange, placeholder }) {
  return <label><span>{label}</span><input type={type} value={value ?? ''} placeholder={placeholder} onChange={(event) => onChange(event.target.value)} /></label>
}

function SettingsTable({ title, addLabel, rows, nameKey, onAdd, onEdit, onDelete }) {
  return <div className="settings-card settings-card-large"><div className="card-header"><h3>{title}</h3><button type="button" className="primary-small-btn" onClick={onAdd}>+ {addLabel}</button></div><div className="table-wrap"><table><thead><tr><th>#</th><th>{nameKey === 'name' ? 'Category Name' : 'Program Type'}</th><th>Description</th><th>Status</th><th>Actions</th></tr></thead><tbody>{rows.map((row, index) => <tr key={row.id}><td>{index + 1}</td><td>{row[nameKey]}</td><td>{row.description}</td><td><span className="status-pill success">{row.status}</span></td><td className="action-cell"><button type="button" className="icon-btn edit" aria-label={`Edit ${row[nameKey]}`} onClick={() => onEdit(row)}>✎</button><button type="button" className="icon-btn delete" aria-label={`Delete ${row[nameKey]}`} onClick={() => onDelete(row.id)}>🗑</button></td></tr>)}</tbody></table></div></div>
}

export default ProgramSettingsPage
