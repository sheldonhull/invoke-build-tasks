# Synopsis: recursively format terraform files
task terraform-fmt {
    try {
        &terraform fmt -recursive
    }
    catch {
        Write-Build DarkYellow "Terraform fmt didn't complete as terraform is likely not installed."
    }
}
