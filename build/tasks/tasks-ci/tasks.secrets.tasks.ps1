#Synopsis: Setup squealer to scan for secrets
check secrets-squealer-setup {
    $ENV:GOPATH  = Join-Path $ENV:HOME 'go'
    $ENV:PATH = "$($ENV:PATH):/Users/$(whoami)/go/bin"
    curl -s 'https://raw.githubusercontent.com/owenrumney/squealer/main/scripts/install.sh' | bash

}
#Synopsis: Use squealer to test for secrets
Task secrets-squealer-scan {
    $ENV:PATH = "$($ENV:PATH):/Users/$(whoami)/go/bin"
    &squealer
}
