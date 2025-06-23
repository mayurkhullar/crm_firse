enum UserRole { admin, manager, teamLeader, salesAgent }

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.teamLeader:
        return 'Team Leader';
      case UserRole.salesAgent:
        return 'Sales Agent';
    }
  }
}
