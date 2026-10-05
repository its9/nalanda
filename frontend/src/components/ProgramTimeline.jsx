import { useState } from 'react'

function parseDate(value) {
  return value ? new Date(`${value}T00:00:00`) : null
}

function dayDifference(left, right) {
  return Math.round((right - left) / 86400000)
}

function formatDate(value) {
  return value ? value.toLocaleDateString(undefined, { day: '2-digit', month: 'short', year: 'numeric' }) : '-'
}

function ProgramTimeline({ programs = [] }) {
  const datedPrograms = programs.map((program) => ({
    ...program,
    start: parseDate(program.startDate),
    end: parseDate(program.endDate),
  })).filter((program) => program.start && program.end)
  const [focusDay, setFocusDay] = useState(0)

  if (!datedPrograms.length) {
    return <section className="panel program-timeline"><div className="panel-title"><span className="panel-label">Program Calendar</span></div><p className="empty-table">No program dates available.</p></section>
  }

  const firstDate = new Date(Math.min(...datedPrograms.map((program) => program.start)))
  const lastDate = new Date(Math.max(...datedPrograms.map((program) => program.end)))
  const totalDays = Math.max(1, dayDifference(firstDate, lastDate))
  const focusDate = new Date(firstDate.getTime() + focusDay * 86400000)
  const position = (date) => `${Math.max(0, Math.min(100, dayDifference(firstDate, date) / totalDays * 100))}%`

  return (
    <section className="panel program-timeline">
      <div className="panel-title"><span className="panel-label">Program Calendar</span><span className="result-count">{formatDate(focusDate)}</span></div>
      <p className="timeline-caption">Move across the calendar. Hover a dot to see when a program starts and ends.</p>
      <input className="timeline-slider" type="range" min="0" max={totalDays} value={focusDay} onChange={(event) => setFocusDay(Number(event.target.value))} aria-label="Program calendar date" />
      <div className="timeline-axis"><span>{formatDate(firstDate)}</span><span>{formatDate(lastDate)}</span></div>
      <div className="timeline-track">{datedPrograms.map((program) => <div className="timeline-program" key={program.id || program.code}>
        <span className="timeline-line" style={{ left: position(program.start), width: `${Math.max(1, parseFloat(position(program.end)) - parseFloat(position(program.start)))}%` }} />
        <span className="timeline-dot start" style={{ left: position(program.start) }} tabIndex="0"><span className="timeline-tooltip"><strong>{program.name}</strong><small>{formatDate(program.start)} - {formatDate(program.end)}</small><small>{program.status}</small></span></span>
        <span className="timeline-dot end" style={{ left: position(program.end) }} tabIndex="0"><span className="timeline-tooltip"><strong>{program.name}</strong><small>{formatDate(program.start)} - {formatDate(program.end)}</small><small>{program.status}</small></span></span>
      </div>)}</div>
      <div className="timeline-legend"><span><i className="start-key" /> Start</span><span><i className="end-key" /> End</span></div>
    </section>
  )
}

export default ProgramTimeline
