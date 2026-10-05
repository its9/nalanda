import { useEffect, useMemo, useState } from "react";
import {
  deleteRole,
  deleteUser,
  getEmployeesForUsers,
  getRolePermissions,
  getRoles,
  getUsers,
  saveRole,
  saveUser,
  updateRolePermissions,
  userAction,
} from "../api/dashboardApi";

const permissionOptions = [
  ["DASHBOARD_VIEW", "View Dashboard"],
  ["USER_VIEW", "View Users"],
  ["USER_CREATE", "Add Users"],
  ["USER_EDIT", "Edit Users"],
  ["USER_DELETE", "Delete Users"],
  ["ROLE_MANAGE", "Manage Roles"],
  ["PROGRAM_VIEW", "View Programs"],
  ["PROGRAM_CREATE", "Create Programs"],
  ["PROGRAM_EDIT", "Edit Programs"],
  ["PROGRAM_DELETE", "Delete Programs"],
  ["NOMINATION_MANAGE", "Manage Nominations"],
  ["ATTENDANCE_MANAGE", "Manage Attendance"],
  ["REPORT_VIEW", "View Reports"],
  ["SETTINGS_MANAGE", "Manage Settings"],
];

function UsersRolesManagement() {
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const [selected, setSelected] = useState(null);
  const [query, setQuery] = useState("");
  const [roleFilter, setRoleFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [tab, setTab] = useState("Users");
  const [error, setError] = useState("");
  const [employeeOptions, setEmployeeOptions] = useState([]);
  const [addUserOpen, setAddUserOpen] = useState(false);
  const [employeeNumber, setEmployeeNumber] = useState("");
  const [newUserRole, setNewUserRole] = useState("");
  const [selectedRoleId, setSelectedRoleId] = useState("");
  const [permissions, setPermissions] = useState([]);
  const [permissionSaving, setPermissionSaving] = useState(false);

  const reload = () =>
    Promise.all([getUsers(), getRoles(), getEmployeesForUsers()])
      .then(([userData, roleData, employeeData]) => {
        setUsers(userData.items || []);
        setRoles(roleData.items || []);
        setEmployeeOptions(employeeData.items || []);
        setSelected((current) =>
          current
            ? (userData.items || []).find((user) => user.id === current.id) ||
              null
            : (userData.items || [])[0] || null,
        );
        setSelectedRoleId(
          (current) => current || String((roleData.items || [])[0]?.id || ""),
        );
      })
      .catch((requestError) => setError(requestError.message));

  useEffect(() => {
    reload();
  }, []);

  useEffect(() => {
    if (!selectedRoleId) return;
    getRolePermissions(selectedRoleId)
      .then((data) => setPermissions(data.permissions || []))
      .catch((requestError) => setError(requestError.message));
  }, [selectedRoleId]);

  const filteredUsers = useMemo(
    () =>
      users.filter((user) => {
        const text =
          `${user.name} ${user.username} ${user.email}`.toLowerCase();
        return (
          (!query || text.includes(query.toLowerCase())) &&
          (!roleFilter || user.role === roleFilter) &&
          (!statusFilter || (statusFilter === "Active") === user.active)
        );
      }),
    [users, query, roleFilter, statusFilter],
  );

  const promptUser = async (user) => {
    const name = window.prompt("User name", user?.name || "");
    if (!name?.trim()) return;
    const username = window.prompt("Username", user?.username || "");
    if (!username?.trim()) return;
    const email = window.prompt("Email", user?.email || "");
    const role = window.prompt(
      "Role code",
      user?.role || roles[0]?.code || "VIEWER",
    );
    if (!role?.trim()) return;
    await saveUser(user?.id, {
      name: name.trim(),
      username: username.trim(),
      email,
      role: role.trim(),
    });
    await reload();
  };

  const addUser = async (event) => {
    event.preventDefault();
    const employee = employeeOptions.find(
      (item) =>
        item.employeeId?.toLowerCase() === employeeNumber.trim().toLowerCase(),
    );
    if (!employee) {
      setError("Employee Number was not found in the database.");
      return;
    }
    if (!newUserRole) {
      setError("Please select a role.");
      return;
    }
    await saveUser(null, {
      name: employee.name,
      username: employee.employeeId,
      email: employee.email || "",
      role: newUserRole,
      employeeId: employee.id,
    });
    setAddUserOpen(false);
    setEmployeeNumber("");
    setNewUserRole("");
    await reload();
  };

  const promptRole = async (role) => {
    const code = window.prompt("Role code", role?.code || "");
    if (!code?.trim()) return;
    const description = window.prompt("Description", role?.description || "");
    await saveRole(role?.id, {
      code: code.trim(),
      name: code.trim(),
      description,
    });
    await reload();
  };

  const savePermissions = async () => {
    setPermissionSaving(true);
    setError("");
    try {
      await updateRolePermissions(selectedRoleId, permissions);
    } catch (requestError) {
      setError(requestError.message);
    } finally {
      setPermissionSaving(false);
    }
  };

  const runUserAction = async (id, action) => {
    await userAction(id, action);
    await reload();
  };

  return (
    <section className="users-roles-page">
      <div className="page-heading">
        <div>
          <div className="section-kicker">👥</div>
          <h2>Users &amp; Roles</h2>
          <p>
            Manage system users, assign roles and control access permissions.
          </p>
        </div>
        <div className="page-actions">
          <button
            type="button"
            className="action-primary"
            onClick={() => setAddUserOpen(true)}
          >
            ＋ Add User
          </button>
          <button
            type="button"
            className="action-secondary"
            onClick={() => promptRole()}
          >
            ＋ Add Role
          </button>
        </div>
      </div>
      {error && <p className="settings-feedback error-message">{error}</p>}
      <div className="users-summary-grid">
        <div className="users-summary-card">
          <strong>{users.length}</strong>
          <span>Total Users</span>
        </div>
        <div className="users-summary-card">
          <strong>{roles.length}</strong>
          <span>Total Roles</span>
        </div>
      </div>
      <div className="users-tabs">
        <button
          type="button"
          className={tab === "Users" ? "active" : ""}
          onClick={() => setTab("Users")}
        >
          👤 Users
        </button>
        <button
          type="button"
          className={tab === "Roles" ? "active" : ""}
          onClick={() => setTab("Roles")}
        >
          🛡 Roles
        </button>
        <button
          type="button"
          className={tab === "Permissions" ? "active" : ""}
          onClick={() => setTab("Permissions")}
        >
          🔧 Permissions
        </button>
      </div>

      {tab === "Users" && (
        <div className="users-content-grid">
          <div className="panel users-list-panel">
            <div className="panel-title">
              <span className="panel-label">Users List</span>
              <button
                type="button"
                className="action-secondary"
                onClick={() =>
                  window.open(
                    `${import.meta.env.VITE_API_URL || "http://localhost:8080/api"}/users/export`,
                    "_blank",
                  )
                }
              >
                Export
              </button>
            </div>
            <div className="users-filters">
              <input
                placeholder="Search by name, email or username..."
                value={query}
                onChange={(event) => setQuery(event.target.value)}
              />
              <select
                value={roleFilter}
                onChange={(event) => setRoleFilter(event.target.value)}
              >
                <option value="">All Roles</option>
                {roles.map((role) => (
                  <option key={role.id} value={role.code}>
                    {role.code}
                  </option>
                ))}
              </select>
              <select
                value={statusFilter}
                onChange={(event) => setStatusFilter(event.target.value)}
              >
                <option value="">All Status</option>
                <option>Active</option>
                <option>Inactive</option>
              </select>
              <button
                type="button"
                className="filter-reset"
                onClick={() => {
                  setQuery("");
                  setRoleFilter("");
                  setStatusFilter("");
                }}
              >
                Reset
              </button>
            </div>
            <div className="employee-table-wrap">
              <table className="employee-table">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredUsers.map((user, index) => (
                    <tr key={user.id} onClick={() => setSelected(user)}>
                      <td>{index + 1}</td>
                      <td>{user.name}</td>
                      <td>{user.username}</td>
                      <td>{user.email || "-"}</td>
                      <td>{user.role}</td>
                      <td>
                        <span
                          className={`employee-status ${user.active ? "active" : "inactive"}`}
                        >
                          {user.active ? "Active" : "Inactive"}
                        </span>
                      </td>
                      <td className="table-actions">
                        <button
                          type="button"
                          onClick={(event) => {
                            event.stopPropagation();
                            promptUser(user);
                          }}
                        >
                          ✎
                        </button>
                        <button
                          type="button"
                          onClick={(event) => {
                            event.stopPropagation();
                            runUserAction(
                              user.id,
                              user.active ? "deactivate" : "activate",
                            );
                          }}
                        >
                          ◉
                        </button>
                        <button
                          type="button"
                          onClick={(event) => {
                            event.stopPropagation();
                            if (window.confirm("Delete this user?"))
                              deleteUser(user.id).then(reload);
                          }}
                        >
                          🗑
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
          <aside className="panel user-details-panel">
            <div className="panel-title">
              <span className="panel-label">User Details</span>
            </div>
            {selected ? (
              <>
                <div className="user-avatar">
                  {selected.name.charAt(0).toUpperCase()}
                </div>
                <h3>{selected.name}</h3>
                <p>
                  <b>Username:</b> {selected.username}
                </p>
                <p>
                  <b>Email:</b> {selected.email || "-"}
                </p>
                <p>
                  <b>Role:</b> {selected.role}
                </p>
                <p>
                  <b>Status:</b> {selected.active ? "Active" : "Inactive"}
                </p>
                <button
                  type="button"
                  className="secondary-btn"
                  onClick={() => runUserAction(selected.id, "reset-password")}
                >
                  Reset Password
                </button>
              </>
            ) : (
              <p className="empty-table">No user selected.</p>
            )}
          </aside>
        </div>
      )}

      {tab === "Roles" && (
        <div className="panel roles-panel">
          <div className="panel-title">
            <span className="panel-label">Roles List</span>
            <button
              type="button"
              className="action-primary"
              onClick={() => promptRole()}
            >
              ＋ Add Role
            </button>
          </div>
          <div className="employee-table-wrap">
            <table className="employee-table">
              <thead>
                <tr>
                  <th>#</th>
                  <th>Role</th>
                  <th>Description</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {roles.map((role, index) => (
                  <tr key={role.id}>
                    <td>{index + 1}</td>
                    <td>{role.code}</td>
                    <td>{role.description || "-"}</td>
                    <td className="table-actions">
                      <button type="button" onClick={() => promptRole(role)}>
                        ✎
                      </button>
                      <button
                        type="button"
                        onClick={() => {
                          if (window.confirm("Delete this role?"))
                            deleteRole(role.id).then(reload);
                        }}
                      >
                        🗑
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {tab === "Permissions" && (
        <div className="panel permissions-panel">
          <div className="panel-title">
            <span className="panel-label">Role Access Control</span>
            <select
              value={selectedRoleId}
              onChange={(event) => setSelectedRoleId(event.target.value)}
            >
              {roles.map((role) => (
                <option key={role.id} value={role.id}>
                  {role.code}
                </option>
              ))}
            </select>
          </div>
          <p>
            Select the access permissions for this role. Changes are saved in
            the database and apply to users assigned to this role.
          </p>
          <div className="permissions-grid">
            {permissionOptions.map(([code, label]) => (
              <label className="permission-checkbox" key={code}>
                <input
                  type="checkbox"
                  checked={permissions.includes(code)}
                  onChange={() =>
                    setPermissions((current) =>
                      current.includes(code)
                        ? current.filter((item) => item !== code)
                        : [...current, code],
                    )
                  }
                />
                <span>{label}</span>
              </label>
            ))}
          </div>
          <button
            type="button"
            className="action-primary"
            disabled={!selectedRoleId || permissionSaving}
            onClick={savePermissions}
          >
            {permissionSaving ? "Saving..." : "Save Permissions"}
          </button>
        </div>
      )}

      {addUserOpen && (
        <div className="employee-modal-backdrop">
          <form className="employee-modal add-user-modal" onSubmit={addUser}>
            <h3>Add User</h3>
            <p className="modal-help">
              Select an employee and assign a role. Name, email and username are
              taken from the employee database record.
            </p>
            <label>
              Employee Number
              <input
                autoFocus
                value={employeeNumber}
                onChange={(event) => setEmployeeNumber(event.target.value)}
                placeholder="e.g. EMP1001"
                required
              />
            </label>
            <label>
              Role
              <select
                value={newUserRole}
                onChange={(event) => setNewUserRole(event.target.value)}
                required
              >
                <option value="">Select role</option>
                {roles.map((role) => (
                  <option key={role.id} value={role.code}>
                    {role.name || role.code}
                  </option>
                ))}
              </select>
            </label>
            <div className="modal-actions">
              <button
                type="button"
                className="action-secondary"
                onClick={() => setAddUserOpen(false)}
              >
                Cancel
              </button>
              <button type="submit" className="action-primary">
                Add User
              </button>
            </div>
          </form>
        </div>
      )}
    </section>
  );
}

export default UsersRolesManagement;
