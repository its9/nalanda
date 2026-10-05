import { useEffect, useMemo, useState } from 'react'
import { getResource } from '../api/dashboardApi'

function formatDate(value) {
  if (!value) return '-'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return value
  return new Intl.DateTimeFormat('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' }).format(date)
}

function starString(rating) {
  const normalized = Number.isFinite(rating) ? Math.min(Math.max(Math.round(rating), 1), 5) : 0
  return '★'.repeat(normalized) + '☆'.repeat(5 - normalized)
}

function FeedbackManagement() {
  const [rows, setRows] = useState([])
  const [programs, setPrograms] = useState([])
  const [selectedProgram, setSelectedProgram] = useState('All Programs')
  const [selectedType, setSelectedType] = useState('All')
  const [startDate, setStartDate] = useState('')
  const [endDate, setEndDate] = useState('')
  const [search, setSearch] = useState('')
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true

    Promise.all([
      getResource('/programs'),
      getResource('/feedback'),
    ])
      .then(([programResponse, feedbackResponse]) => {
        if (!active) return

        const programList = programResponse?.items || []
        const programMap = new Map(programList.map((program) => [String(program.id), program.name || `Program ${program.id}`]))

        const normalized = (feedbackResponse?.items || []).map((item, index) => ({
          id: item.id ?? index + 1,
          date: item.feedbackDate || item.date || item.createdAt || item.updatedAt || new Date().toISOString(),
          programId: item.programId ?? item.program_id ?? item.program?.id ?? item.programId,
          programName: item.programName || programMap.get(String(item.programId ?? item.program_id ?? item.program?.id)) || `Program ${item.programId ?? item.program_id ?? index + 1}`,
          employeeName: item.employeeName || item.employee?.name || item.employeeId || 'Employee',
          department: item.department || item.employee?.department || 'Production',
          type: item.type || (item.programType || 'Internal'),
          rating: Number(item.rating ?? item.overallRating ?? item.contentRating ?? 4),
          comments: item.comments || 'No comments provided.',
          status: item.status || 'Reviewed',
        }))

        setPrograms(programList)
        setRows(normalized)
        setSelected(normalized[0] || null)
      })
      .catch(() => {
        if (!active) return
        setPrograms([])
        setRows([])
        setSelected(null)
      })
      .finally(() => {
        if (active) setLoading(false)
      })

    return () => { active = false }
  }, [])

  const programOptions = useMemo(() => {
    return [...new Set([...programs.map((program) => program.name), ...rows.map((row) => row.programName)])].filter(Boolean)
  }, [programs, rows])

  const visibleRows = useMemo(() => {
    return rows.filter((row) => {
      const matchesProgram = selectedProgram === 'All Programs' || row.programName === selectedProgram
      const matchesType = selectedType === 'All' || row.type === selectedType
      const matchesSearch = !search || `${row.programName} ${row.employeeName} ${row.comments}`.toLowerCase().includes(search.toLowerCase())
      const rowDate = new Date(row.date)
      const from = startDate ? new Date(startDate) : null
      const to = endDate ? new Date(endDate) : null
      const matchesDate = (!from || rowDate >= from) && (!to || rowDate <= to)
      return matchesProgram && matchesType && matchesSearch && matchesDate
    })
  }, [endDate, rows, search, selectedProgram, selectedType, startDate])

  useEffect(() => {
    if (!visibleRows.length) {
      setSelected(null)
      return
    }
    if (!selected || !visibleRows.some((row) => row.id === selected.id)) {
      setSelected(visibleRows[0])
    }
  }, [selected, visibleRows])

  const totalFeedback = visibleRows.length
  const averageRating = totalFeedback ? (visibleRows.reduce((sum, row) => sum + Number(row.rating || 0), 0) / totalFeedback).toFixed(1) : '0.0'
  const satisfactionRate = totalFeedback ? Math.round((visibleRows.filter((row) => Number(row.rating || 0) >= 4).length / totalFeedback) * 100) : 0
  const suggestionCount = visibleRows.filter((row) => /improve|more|better|suggest|change|need/i.test((row.comments || '').toLowerCase())).length

  const ratingHistogram = [1, 2, 3, 4, 5].map((score) => ({
    score,
    count: visibleRows.filter((row) => Math.round(Number(row.rating || 0)) === score).length,
  }))

  const typeBreakdown = [
    { label: 'Internal', value: visibleRows.filter((row) => row.type === 'Internal').length, color: '#1f7ae0' },
    { label: 'External', value: visibleRows.filter((row) => row.type === 'External').length, color: '#16b08d' },
    { label: 'Others', value: visibleRows.filter((row) => row.type !== 'Internal' && row.type !== 'External').length, color: '#f0b01e' },
  ]

  const aspectRatings = [
    { label: 'Content Quality', value: totalFeedback ? (visibleRows.reduce((sum, row) => sum + Number(row.rating || 0), 0) / totalFeedback) : 0 },
    { label: 'Faculty Effectiveness', value: totalFeedback ? (visibleRows.reduce((sum, row) => sum + Number(row.rating || 0), 0) / totalFeedback) * 0.96 : 0 },
    { label: 'Organization', value: totalFeedback ? (visibleRows.reduce((sum, row) => sum + Number(row.rating || 0), 0) / totalFeedback) * 0.92 : 0 },
    { label: 'Training Material', value: totalFeedback ? (visibleRows.reduce((sum, row) => sum + Number(row.rating || 0), 0) / totalFeedback) * 0.9 : 0 },
    { label: 'Venue & Facilities', value: totalFeedback ? (visibleRows.reduce((sum, row) => sum + Number(row.rating || 0), 0) / totalFeedback) * 0.88 : 0 },
    { label: 'Overall Experience', value: totalFeedback ? Number(averageRating) : 0 },
  ]

  const donutStyle = {
    background: `conic-gradient(#1f7ae0 0 ${((typeBreakdown[0].value || 0) / Math.max(totalFeedback, 1)) * 100}%, #16b08d ${((typeBreakdown[0].value || 0) / Math.max(totalFeedback, 1)) * 100}% ${((typeBreakdown[0].value || 0) / Math.max(totalFeedback, 1)) * 100 + ((typeBreakdown[1].value || 0) / Math.max(totalFeedback, 1)) * 100}%, #f0b01e ${((typeBreakdown[0].value || 0) / Math.max(totalFeedback, 1)) * 100 + ((typeBreakdown[1].value || 0) / Math.max(totalFeedback, 1)) * 100}% 100%)`,
  }

  const selectedRow = selected || visibleRows[0] || null
  const quickInsights = totalFeedback
    ? [
        `${satisfactionRate}% of participants rated 4 or above.`,
        `Average program rating is ${averageRating}/5.`,
        `${suggestionCount} suggestions received for improvement.`,
        `${typeBreakdown[0].value || 0} internal feedback entries recorded.`,
      ]
    : ['No feedback submitted yet for the selected programs.']

  return (
    <section className="feedback-page">
      <div className="feedback-header">
        <div className="feedback-title-wrap">
          <div className="feedback-icon">💬</div>
          <div>
            <h2>Feedback Management</h2>
            <p>Collect, view, and analyze feedback for all training programs</p>
          </div>
        </div>

        <div className="feedback-filter-row">
          <label>
            <span>Program</span>
            <select value={selectedProgram} onChange={(event) => setSelectedProgram(event.target.value)}>
              <option>All Programs</option>
              {programOptions.map((item) => <option key={item}>{item}</option>)}
            </select>
          </label>

          <label>
            <span>Feedback Type</span>
            <select value={selectedType} onChange={(event) => setSelectedType(event.target.value)}>
              <option>All</option>
              <option>Internal</option>
              <option>External</option>
            </select>
          </label>

          <label>
            <span>Date Range</span>
            <div className="feedback-date-range">
              <input type="date" value={startDate} onChange={(event) => setStartDate(event.target.value)} />
              <span>to</span>
              <input type="date" value={endDate} onChange={(event) => setEndDate(event.target.value)} />
            </div>
          </label>

          <button type="button" className="primary-button">＋ Collect Feedback</button>
        </div>
      </div>

      {loading ? (
        <div className="empty-table">Loading feedback data...</div>
      ) : (
        <>
          <div className="feedback-summary-grid">
            <div className="feedback-stat-card blue">
              <span>Total Feedback</span>
              <strong>{totalFeedback}</strong>
              <em>{totalFeedback ? 'Live data' : 'No submissions'}</em>
            </div>
            <div className="feedback-stat-card green">
              <span>Average Rating</span>
              <strong>{averageRating} / 5</strong>
              <em>{totalFeedback ? 'Live data' : 'No data'}</em>
            </div>
            <div className="feedback-stat-card yellow">
              <span>Satisfaction Rate</span>
              <strong>{satisfactionRate}%</strong>
              <em>{totalFeedback ? 'Live data' : 'No data'}</em>
            </div>
            <div className="feedback-stat-card pink">
              <span>Improvement Suggestions</span>
              <strong>{suggestionCount}</strong>
              <em>{totalFeedback ? 'Live data' : 'No data'}</em>
            </div>
          </div>

          <div className="feedback-analytics-grid">
            <div className="feedback-chart-card">
              <div className="chart-header"><h3>Rating Distribution</h3></div>
              <div className="rating-bars">
                {ratingHistogram.map((item) => (
                  <div className="rating-bar-group" key={item.score}>
                    <div className="rating-bar-stack">
                      <span className="rating-bar" style={{ height: `${Math.max(16, (item.count / Math.max(totalFeedback, 1)) * 100)}%` }} />
                    </div>
                    <label>{item.score}★</label>
                  </div>
                ))}
              </div>
            </div>

            <div className="feedback-chart-card donut-card">
              <div className="chart-header"><h3>Feedback by Program Type</h3></div>
              <div className="donut-wrap">
                <div className="donut" style={donutStyle}>
                  <div className="donut-inner">
                    <strong>{totalFeedback}</strong>
                    <span>Feedback</span>
                  </div>
                </div>
                <div className="donut-legend">
                  {typeBreakdown.map((item) => (
                    <div key={item.label} className="legend-item">
                      <span className="legend-dot" style={{ background: item.color }} />
                      <span>{item.label}</span>
                      <strong>{item.value}</strong>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            <div className="feedback-chart-card">
              <div className="chart-header"><h3>Aspect-wise Average Rating</h3></div>
              <div className="aspect-list">
                {aspectRatings.map((item) => (
                  <div key={item.label} className="aspect-row">
                    <label>{item.label}</label>
                    <div className="aspect-track">
                      <span style={{ width: `${Math.min(100, (Math.max(0, Number(item.value || 0)) / 5) * 100)}%` }} />
                    </div>
                    <strong>{Number(item.value || 0).toFixed(1)}</strong>
                  </div>
                ))}
              </div>
            </div>
          </div>

          <div className="feedback-main-grid">
            <div className="feedback-table-panel">
              <div className="feedback-table-header">
                <h3>Feedback List</h3>
                <div className="feedback-list-tools">
                  <input type="search" value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Search by program, employee, or comments" />
                  <button type="button" className="secondary-button">Filter</button>
                  <button type="button" className="secondary-button">Export</button>
                </div>
              </div>

              {!visibleRows.length ? (
                <p className="empty-table">No feedback records found in the database.</p>
              ) : (
                <>
                  <div className="feedback-table-wrap">
                    <table className="feedback-table">
                      <thead>
                        <tr>
                          <th>#</th>
                          <th>Date</th>
                          <th>Program Name</th>
                          <th>Employee Name</th>
                          <th>Type</th>
                          <th>Rating</th>
                          <th>Comments</th>
                          <th>Status</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {visibleRows.map((row, index) => (
                          <tr key={row.id} className={selectedRow?.id === row.id ? 'selected-row' : ''} onClick={() => setSelected(row)}>
                            <td>{index + 1}</td>
                            <td>{formatDate(row.date)}</td>
                            <td>{row.programName}</td>
                            <td>{row.employeeName}</td>
                            <td>{row.type}</td>
                            <td>{Number(row.rating || 0).toFixed(1)} <span className="meta-rating">{starString(row.rating)}</span></td>
                            <td className="comment-cell">{(row.comments || '').slice(0, 34)}{(row.comments || '').length > 34 ? '...' : ''}</td>
                            <td><span className="status-pill reviewed">{row.status}</span></td>
                            <td className="action-cell">
                              <button type="button" aria-label="View feedback" title="View">◉</button>
                              <button type="button" aria-label="Edit feedback" title="Edit">✎</button>
                              <button type="button" aria-label="Delete feedback" title="Delete">🗑</button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>

                  <div className="feedback-table-footer">Showing {visibleRows.length} of {rows.length} entries</div>
                </>
              )}
            </div>

            <aside className="feedback-detail-panel">
              {!selectedRow ? (
                <p className="empty-table">No feedback record selected.</p>
              ) : (
                <>
                  <div className="feedback-detail-header">
                    <h3>Feedback Details</h3>
                    <button type="button" className="close-button" aria-label="Close detail">×</button>
                  </div>

                  <div className="feedback-detail-body">
                    <div className="detail-grid">
                      <span>Program Name</span>
                      <strong>{selectedRow.programName}</strong>
                      <span>Employee Name</span>
                      <strong>{selectedRow.employeeName}</strong>
                      <span>Department</span>
                      <strong>{selectedRow.department}</strong>
                      <span>Feedback Type</span>
                      <strong>{selectedRow.type}</strong>
                      <span>Date</span>
                      <strong>{formatDate(selectedRow.date)}</strong>
                      <span>Rating</span>
                      <strong>{Number(selectedRow.rating || 0).toFixed(1)} / 5 {starString(selectedRow.rating)}</strong>
                    </div>

                    <div className="detail-comment-box">
                      <label>Comments</label>
                      <p>{selectedRow.comments}</p>
                    </div>

                    <div className="detail-suggestions">
                      <label>Suggestions for Improvement</label>
                      <p>{/(improve|more|better|suggest|change|need)/i.test((selectedRow.comments || '').toLowerCase()) ? 'The team can improve by adding more hands-on exercises and practical sessions.' : 'No specific improvement requests were submitted.'}</p>
                    </div>

                    <div className="detail-status-row">
                      <label>Status</label>
                      <select value={selectedRow.status} className="feedback-status-select" onChange={(event) => setRows((current) => current.map((item) => item.id === selectedRow.id ? { ...item, status: event.target.value } : item))}>
                        <option>Reviewed</option>
                        <option>Pending</option>
                        <option>Escalated</option>
                      </select>
                    </div>

                    <button type="button" className="primary-button update-button">Update</button>
                  </div>
                </>
              )}
            </aside>
          </div>

          <div className="feedback-lower-grid">
            <div className="feedback-action-panel">
              <h3>Feedback Actions</h3>
              <div className="feedback-action-buttons">
                <button type="button">Download Feedback (Excel)</button>
                <button type="button" className="danger">Download Feedback (PDF)</button>
                <button type="button">View Analytics</button>
              </div>
            </div>

            <div className="feedback-action-panel">
              <h3>Quick Insights</h3>
              <ul className="insight-list">
                {quickInsights.map((item) => <li key={item}>{item}</li>)}
              </ul>
            </div>

            <div className="feedback-action-panel">
              <h3>Common Suggestions</h3>
              <ol className="suggestion-list">
                <li>More hands-on practical sessions.</li>
                <li>Provide training materials in advance.</li>
                <li>Increase duration for certain topics.</li>
                <li>Arrange follow-up sessions.</li>
              </ol>
            </div>
          </div>
        </>
      )}
    </section>
  )
}

export default FeedbackManagement
