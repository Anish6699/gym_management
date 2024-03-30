class Project {
  final String? title, description;

  Project({this.title, this.description});
}

List<Project> demo_projects = [
  Project(
      title: "User Authentication",
      description:
          " Implement a secure authentication system to allow members, visitors, and trainers to log in with their credentials."),
  Project(
    title: "User Roles",
    description:
        "Define different roles for members, visitors, and trainers, each with their own set of permissions and access levels.",
  ),
  Project(
      title: "Member Registration",
      description:
          "Allow new users to register as members, providing necessary information such as name, email, and contact details."),
  Project(
    title: "Visitor Management",
    description:
        "Enable visitors to sign up for temporary access to facilities or classes, capturing basic information and possibly allowing for quick registration.",
  ),
  Project(
    title: "Trainer",
    description:
        "Create profiles for trainers, including details such as their specialties, qualifications",
  ),
  Project(
    title: "Expense Tracker",
    description:
        "Tracks the Expenses of Branch on aily basis and help us to track the expenses Monthly and Yearly",
  ),
  Project(
    title: "Send Notification",
    description:
        "Implement features for automatic or manual notification sending to targeted Audiance through Mail.",
  ),
  Project(
    title: "Membership Renewal",
    description:
        "Implement features for automatic or manual renewal of membership subscriptions.",
  ),
  Project(
      title: "Branch Dashboard",
      description:
          "Create a comprehensive dashboard for branch administrators which includes overall view of branch."),
  Project(
    title: "Admin Dashboard",
    description:
        "Create a comprehensive dashboard for administrators(Owner) which includes overall view and Comparison of branches.",
  ),
  Project(
      title: "Data Security",
      description:
          "Implement measures to protect user data, including encryption, access controls, and regular backups."),
  Project(
    title: "Continuous Improvement",
    description:
        "Gather feedback from users and stakeholders to continually enhance the application's features, usability, and performance.",
  ),
];
