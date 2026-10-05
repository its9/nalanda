function StatCard({ label, value, change, tone }) {
  return (
    <article className={`stat-card ${tone}`}>
      <div className="stat-head">
        <span className="muted-label">{label}</span>
        <span className="trend">{change}</span>
      </div>
      <strong>{value}</strong>
    </article>
  )
}

export default StatCard
