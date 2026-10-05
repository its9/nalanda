function RecentActivity({ activities }) {
  return (
    <aside className="panel activity-panel">
      <div className="panel-header">
        <div>
          <p className="eyebrow">Updates</p>
          <h3>Recent Activity</h3>
        </div>
      </div>

      <ul className="activity-list">
        {activities.map((item) => (
          <li key={item.title} className="activity-item">
            <span className={`dot ${item.color}`} />
            <div>
              <strong>{item.title}</strong>
              <p>{item.detail}</p>
            </div>
          </li>
        ))}
      </ul>
    </aside>
  )
}

export default RecentActivity
