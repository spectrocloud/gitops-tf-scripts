//# role
//data "spectrocloud_role" "projectadmin" {
//  name   = "Project Admin"
//}
//
//data "spectrocloud_role" "clusteradmin" {
//  name   = "Cluster Admin"
//}
//
//data "spectrocloud_role" "clusterviewer" {
//  name   = "Cluster Viewer"
//}
//
//# project
//data "spectrocloud_project" "project" {
//  name = var.sc_project_name
//}
//
//resource "spectrocloud_team" "projectadmin" {
//  name                       = format("%s-Project-Admin", var.sc_project_name)
//
//  project_role_mapping {
//    id = data.spectrocloud_project.project.id
//    roles = [data.spectrocloud_role.projectadmin.id]
//  }
//}
//
//resource "spectrocloud_team" "clusteradmin" {
//  name                       = format("%s-Cluster-Admin", var.sc_project_name)
//
//  project_role_mapping {
//    id = data.spectrocloud_project.project.id
//    roles = [data.spectrocloud_role.clusteradmin.id]
//  }
//}
//
//resource "spectrocloud_team" "clusterviewer" {
//  name                       = format("%s-Cluster-Viewer", var.sc_project_name)
//
//  project_role_mapping {
//    id = data.spectrocloud_project.project.id
//    roles = [data.spectrocloud_role.clusterviewer.id]
//  }
//}