import { useEffect, useMemo, useRef, useState } from 'react'
import { createProgramFolder, deleteDocument, deleteProgramFolder, getDocumentDownloadUrl, getDocumentPreviewUrl, getDocuments, getProgramFolders, getPrograms, uploadDocument } from '../api/dashboardApi'
import ConfirmDialog from './ConfirmDialog'

const tabs = ['All Documents', 'PDF', 'DOCX', 'XLSX', 'PPTX', 'Images']

function formatSize(bytes) {
  if (!bytes) return '-'
  if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

function formatDate(value) {
  if (!value) return '-'
  return new Intl.DateTimeFormat('en-GB').format(new Date(value))
}

function documentType(document) {
  const extension = document.filename?.split('.').pop()?.toUpperCase()
  return extension || document.contentType?.split('/').pop()?.toUpperCase() || 'FILE'
}

function DocumentManagement() {
  const [programs, setPrograms] = useState([])
  const [selectedProgram, setSelectedProgram] = useState('')
  const [documents, setDocuments] = useState([])
  const [activeTab, setActiveTab] = useState('All Documents')
  const [search, setSearch] = useState('')
  const [selected, setSelected] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [uploading, setUploading] = useState(false)
  const [confirmDelete, setConfirmDelete] = useState(null)
  const [pendingDeletion, setPendingDeletion] = useState(null)
  const [remainingSeconds, setRemainingSeconds] = useState(5)
  const [showFolderDialog, setShowFolderDialog] = useState(false)
  const [folderName, setFolderName] = useState('')
  const [folders, setFolders] = useState([])
  const [selectedFolder, setSelectedFolder] = useState('')
  const [expandedFolders, setExpandedFolders] = useState(new Set())
  const undoTimer = useRef(null)
  const countdownTimer = useRef(null)
  const fileInput = useRef(null)

  useEffect(() => {
    getPrograms()
      .then((response) => {
        const items = response.items || []
        setPrograms(items)
        if (items[0]) setSelectedProgram(String(items[0].id))
      })
      .catch(() => setError('Unable to load programs from the database.'))
  }, [])

  useEffect(() => {
    setLoading(true)
    setSelected([])
    if (selectedProgram) getProgramFolders(selectedProgram).then((items) => {
      setFolders(items)
      setExpandedFolders(new Set(items.filter((item) => !item.includes('/'))))
    }).catch(() => setFolders([]))
    else { setFolders([]); setExpandedFolders(new Set()) }
    setSelectedFolder('')
    getDocuments(selectedProgram || undefined)
      .then((response) => {
        setDocuments(response.items || [])
        setError('')
      })
      .catch(() => setError('Unable to load documents from the database.'))
      .finally(() => setLoading(false))
  }, [selectedProgram])

  const visibleDocuments = useMemo(() => documents.filter((document) => {
    const type = documentType(document)
    const matchesSearch = `${document.filename} ${document.contentType}`.toLowerCase().includes(search.toLowerCase())
    const matchesTab = activeTab === 'All Documents' || (activeTab === 'Images' ? ['JPG', 'JPEG', 'PNG', 'GIF', 'WEBP'].includes(type) : type === activeTab)
    const matchesFolder = !selectedFolder || document.folder === selectedFolder
    return matchesSearch && matchesTab && matchesFolder
  }), [activeTab, documents, search, selectedFolder])

  const currentProgram = programs.find((program) => String(program.id) === selectedProgram)

  async function handleUpload(event) {
    const file = event.target.files?.[0]
    event.target.value = ''
    if (!file || !selectedProgram || !selectedFolder) return
    setUploading(true)
    try {
      const uploaded = await uploadDocument(file, selectedProgram, selectedFolder)
      setDocuments((current) => [...current, uploaded])
      setError('')
    } catch (uploadError) {
      setError(uploadError.message)
    } finally {
      setUploading(false)
    }
  }

  function queueDeletion(ids) {
    const removed = documents.filter((document) => ids.includes(document.id))
    if (!removed.length) return
    if (undoTimer.current) clearTimeout(undoTimer.current)
    if (countdownTimer.current) clearInterval(countdownTimer.current)
    setDocuments((current) => current.filter((document) => !ids.includes(document.id)))
    setSelected((current) => current.filter((documentId) => !ids.includes(documentId)))
    setPendingDeletion({ documents: removed })
    setRemainingSeconds(5)
    countdownTimer.current = setInterval(() => setRemainingSeconds((current) => Math.max(current - 1, 0)), 1000)
    undoTimer.current = setTimeout(() => {
      Promise.all(removed.map((document) => deleteDocument(document.id)))
        .catch((deleteError) => setError(deleteError.message))
        .finally(() => {
          clearInterval(countdownTimer.current)
          setPendingDeletion(null)
        })
    }, 5000)
  }

  function undoDeletion() {
    if (!pendingDeletion) return
    clearTimeout(undoTimer.current)
    clearInterval(countdownTimer.current)
    setDocuments((current) => [...current, ...pendingDeletion.documents])
    setPendingDeletion(null)
  }

  function toggleAll() {
    setSelected(selected.length === visibleDocuments.length ? [] : visibleDocuments.map((document) => document.id))
  }

  function toggleFolder(folder) {
    setSelectedFolder(folder)
    if (!folders.some((item) => item.startsWith(`${folder}/`))) return
    setExpandedFolders((current) => {
      const next = new Set(current)
      if (next.has(folder)) next.delete(folder)
      else next.add(folder)
      return next
    })
  }

  function folderVisible(folder) {
    const parts = folder.split('/')
    return parts.slice(0, -1).every((_, index) => expandedFolders.has(parts.slice(0, index + 1).join('/')))
  }

  function folderItemCount(folder) {
    return documents.filter((document) => document.folder === folder || document.folder?.startsWith(`${folder}/`)).length
  }

  async function handleCreateFolder(event) {
    event.preventDefault()
    if (!selectedProgram || !folderName.trim()) return
    try {
      const createdFolder = await createProgramFolder(selectedProgram, folderName, selectedFolder)
      setFolders(await getProgramFolders(selectedProgram))
      setSelectedFolder(createdFolder.name)
      setFolderName('')
      setShowFolderDialog(false)
      setError('Folder created inside the selected program.')
    } catch (folderError) {
      setError(folderError.message)
    }
  }

  async function handleDeleteFolder(folder) {
    if (!selectedProgram || !folder) return
    try {
      await deleteProgramFolder(selectedProgram, folder)
      const refreshedFolders = await getProgramFolders(selectedProgram)
      setFolders(refreshedFolders)
      setExpandedFolders(new Set(refreshedFolders.filter((item) => !item.includes('/'))))
      setDocuments((current) => current.filter((document) => document.folder !== folder && !document.folder?.startsWith(`${folder}/`)))
      if (selectedFolder === folder) setSelectedFolder('')
      setError('Folder deleted from the program.')
    } catch (folderError) {
      setError(folderError.message)
    }
  }

  return (
    <section className="document-page">
      <div className="document-heading">
        <div className="document-title-wrap"><div className="document-icon">▤</div><div><h2>Document Management</h2><p>Store, organize and access documents uploaded to each program</p></div></div>
        <div className="storage-box"><span className="storage-icon">▰</span><div><small>Documents in selected program</small><strong>{documents.length} files</strong><i><b style={{ width: `${Math.min(documents.length * 8, 100)}%` }} /></i><em>{selectedProgram ? 'Database data' : 'Select a program'}</em></div></div>
          <button type="button" className="primary-action" disabled={!selectedProgram || !selectedFolder || uploading} onClick={() => fileInput.current?.click()}>＋ {uploading ? 'Uploading...' : 'Upload Document'}</button>
        <input ref={fileInput} className="visually-hidden" type="file" onChange={handleUpload} />
      </div>

      <div className="document-tabs">{tabs.map((tab) => <button type="button" key={tab} className={activeTab === tab ? 'active' : ''} onClick={() => setActiveTab(tab)}>{tab === 'All Documents' ? 'All Documents' : tab}</button>)}</div>

      <div className="document-layout">
        <aside className="document-sidebar">
          <div className="subpanel folder-panel"><h3>Program Folders</h3><label className="program-select-label" htmlFor="program-select">Select program</label><select id="program-select" className="program-select" value={selectedProgram} onChange={(event) => setSelectedProgram(event.target.value)} disabled={!programs.length}><option value="">{programs.length ? 'Choose a program...' : 'No programs found'}</option>{programs.map((program) => <option value={program.id} key={program.id}>{program.code ? `${program.code} - ` : ''}{program.name || `Program ${program.id}`}</option>)}</select>{folders.length > 0 && <div className="program-folder-list"><div className="folder-tree-root">⌄ 📁 All Programs</div><div className="folder-tree-program">⌄ 📁 {currentProgram?.name || 'Selected Program'}</div>          {folders.filter(folderVisible).map((folder) => { const depth = folder.split('/').length - 1; const hasChildren = folders.some((item) => item.startsWith(`${folder}/`)); const isOpen = expandedFolders.has(folder); return <div className="folder-item-row" key={folder} style={{ paddingLeft: `${8 + depth * 14}px` }}><button type="button" className={selectedFolder === folder ? 'active' : ''} onClick={() => toggleFolder(folder)}>{hasChildren ? (isOpen ? '⌄' : '›') : '•'} 📁 {folder.split('/').pop()} <small>({folderItemCount(folder)})</small></button><button type="button" className="folder-delete-button" aria-label={`Delete folder ${folder.split('/').pop()}`} onClick={(event) => { event.stopPropagation(); setConfirmDelete({ type: 'folder', folder, message: `Delete the folder “${folder.split('/').pop()}” and all files inside it?` }) }}>🗑</button></div> })}</div>}{error && !programs.length ? <p className="empty-table">Unable to load programs.</p> : !programs.length && <p className="program-empty-state">No programs in the database. Create or import a program first.</p>}</div>          <div className="subpanel quick-upload"><h3>ⓘ Quick Upload</h3><button type="button" className="upload-dropzone" disabled={!selectedProgram || !selectedFolder || uploading} onClick={() => fileInput.current?.click()}><strong>☁</strong><span>{selectedFolder ? 'Drag &amp; drop files here' : 'Select or create a folder first'}</span><small>or</small><b>Choose Files</b></button><p>Files are uploaded to the selected folder.</p></div>
        </aside>

        <div className="document-content">
          <div className="document-toolbar"><span>📁 Programs　›　<strong>{currentProgram?.name || 'Select a program'}</strong>　›　{selectedFolder}</span><div><input type="search" value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Search documents..." /><button type="button" onClick={() => { setActiveTab('All Documents'); setSelectedFolder('') }}>⚑ Clear Filter</button></div></div>
          {error && <p className="document-error">{error}</p>}
            <div className="document-table-panel"><table className="document-table"><thead><tr><th><input type="checkbox" checked={visibleDocuments.length > 0 && selected.length === visibleDocuments.length} onChange={toggleAll} /></th><th>#</th><th>File Name</th><th>Type</th><th>Size</th><th>Upload Date</th><th>Actions</th></tr></thead><tbody>{visibleDocuments.map((document, index) => { const type = documentType(document); return <tr key={document.id}><td><input type="checkbox" checked={selected.includes(document.id)} onChange={() => setSelected((current) => current.includes(document.id) ? current.filter((id) => id !== document.id) : [...current, document.id])} /></td><td>{index + 1}</td><td><span className={`file-badge ${type.toLowerCase()}`}>▤</span>{document.filename}</td><td>{type}</td><td>{formatSize(document.size)}</td><td>{formatDate(document.uploadedAt)}</td><td className="row-actions"><a href={getDocumentPreviewUrl(document.id)} target="_blank" rel="noreferrer" title="Open file">◉</a><a href={getDocumentDownloadUrl(document.id)} title="Download">↓</a><button type="button" title="Delete" onClick={() => setConfirmDelete({ ids: [document.id], message: 'Delete this document from the database?' })}>🗑</button></td></tr> })}</tbody></table>{loading && <p className="empty-table">Loading documents...</p>}{!loading && !visibleDocuments.length && <p className="empty-table">No documents uploaded for this program.</p>}<div className="table-footer"><span>Showing {visibleDocuments.length} of {documents.length} documents</span></div></div>

          <div className="document-bottom-grid"><div className="subpanel recent-documents"><div className="subpanel-heading"><h3>▤ Recent Documents</h3></div>{documents.slice(-5).reverse().map((document) => <div className="recent-row" key={`recent-${document.id}`}><span className={`file-badge ${documentType(document).toLowerCase()}`}>▤</span><strong>{document.filename}</strong><small>{documentType(document)}</small><small>{formatSize(document.size)}</small><small>{formatDate(document.uploadedAt)}</small></div>)}{!documents.length && <p className="empty-table">No recent documents.</p>}</div><div className="subpanel statistics"><h3>▣ Document Statistics</h3><div className="stats-content"><div className="document-donut"><strong>{documents.length}</strong><span>Documents</span></div><span className="live-data-note">Calculated from selected program</span></div></div><div className="subpanel quick-actions-doc"><h3>▣ Quick Actions</h3><button type="button" disabled={!selectedProgram} onClick={() => setShowFolderDialog(true)}>＋ Create Folder</button><button type="button" disabled={!selectedProgram} onClick={() => fileInput.current?.click()}>＋ Upload Document</button><button type="button" onClick={() => setSelected([])}>□ Clear Selection</button><button type="button" disabled={!selected.length}>▣ Download Selected</button><button type="button" className="danger" disabled={!selected.length} onClick={() => setConfirmDelete({ ids: selected, message: `Delete ${selected.length} selected document${selected.length === 1 ? '' : 's'}?` })}>▣ Delete Selected</button></div></div>
        </div>
      </div>
      {confirmDelete && <ConfirmDialog message={confirmDelete.message} onCancel={() => setConfirmDelete(null)} onConfirm={() => {
        if (confirmDelete.type === 'folder') {
          handleDeleteFolder(confirmDelete.folder)
        } else {
          queueDeletion(confirmDelete.ids)
        }
        setConfirmDelete(null)
      }} />}
      {pendingDeletion && <div className="undo-toast" role="status"><span>{pendingDeletion.documents.length} document{pendingDeletion.documents.length === 1 ? '' : 's'} removed</span><small>{remainingSeconds}s</small><button type="button" onClick={undoDeletion}>Undo</button></div>}
      {showFolderDialog && <div className="confirm-backdrop"><form className="confirm-dialog folder-dialog" onSubmit={handleCreateFolder}><h3>Create Folder</h3><p>Create a folder inside {currentProgram?.name || 'the selected program'}.</p><input autoFocus required value={folderName} onChange={(event) => setFolderName(event.target.value)} placeholder="Folder name" /><div className="confirm-actions"><button type="button" onClick={() => setShowFolderDialog(false)}>Cancel</button><button type="submit" className="primary-action">Create</button></div></form></div>}
    </section>
  )
}

export default DocumentManagement