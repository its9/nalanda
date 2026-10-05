function ProgramTable({ programs }) {
  return (
    <section className="panel">
      <div className="panel-header">
        <div>
          <p className="eyebrow">Overview</p>
          <h3>Programs</h3>
        </div>
        <button type="button" className="link-btn">View all</button>
      </div>

      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Program</th>
              <th>Owner</th>
              <th>Dates</th>
              <th>Status</th>
              <th>Progress</th>
            </tr>
          </thead>
          <tbody>
            {programs.map((program) => (
              <tr key={program.name}>
                <td>{program.name}</td>
                <td>{program.owner}</td>
                <td>{program.dates}</td>
                <td>
                  <span className={`status-pill ${program.status.toLowerCase().replace(/\s+/g, '-')}`}>
                    {program.status}
                  </span>
                </td>
                <td>
                  <div className="progress-wrap">
                    <div className="progress-bar" style={{ width: `${program.progress}%` }} />
                  </div>
                  <small>{program.progress}%</small>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  )
}

export default ProgramTable
