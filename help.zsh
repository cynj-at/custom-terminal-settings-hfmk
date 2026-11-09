# help — shared between users (no secrets, no user-specific paths)

sos() {
    cat <<'EOF'
Custom Shell Functions:

Navigation:
  up [N]             - Go up N directories (default 1)
  home               - Go to your home directory
  proj [name]        - Go to ~/dev/[name] project folder

Search / Find:
  f [pattern]        - Find files by name
  g [pattern]        - Search text recursively in files

System / Process:
  killp [name]       - Kill process by name
  duh [dir]          - Show disk usage of directories sorted
  topc               - Show top 20 CPU/memory consuming processes
  ncpu               - Number of CPUs

File Helpers:
  mkcd [dir]         - Make directory and enter it
  mvdir [src] [dest] - Move whole directory to new location
  extract [file]     - Extract archive based on file type

Networking / Dev:
  serve [port]       - Start Python HTTP server on port (default 8000)
  myip               - Show local IP addresses
  portopen [port]    - Check if port is open on localhost

Productivity / Misc:
  r [pattern]        - Re-run last command starting with pattern
  backup [file]      - Make a timestamped backup of a file

EOF
}

sosgit() {
    BOLD=$'\e[1m'
    GREEN=$'\e[32m'
    CYAN=$'\e[36m'
    RESET=$'\e[0m'

    cat <<EOF
${BOLD}Repository Setup:${RESET}
  ${GREEN}git clone https://github.com/davemod/25_juce1.git${RESET}

${BOLD}Täglicher Workflow:${RESET}
  ${GREEN}git fetch${RESET}
    -> Lädt neue Änderungen vom Remote-Repository, ohne sie in den aktuellen Branch zu integrieren.

  ${GREEN}git pull${RESET}
    -> Holt neue Änderungen vom Remote-Repository und integriert sie direkt in den aktuellen Branch.

  ${GREEN}git status${RESET}
    -> Zeigt den aktuellen Stand der Arbeitskopie, inklusive Änderungen und Staging-Bereich.

  ${GREEN}git add${RESET}
    -> Verschiebt ausgewählte Änderungen in den Staging-Bereich, um sie für den nächsten Commit vorzubereiten.

  ${GREEN}git restore --staged${RESET}
    -> Entfernt Änderungen aus dem Staging-Bereich, ohne sie aus den Dateien zu löschen.

  ${GREEN}git restore${RESET}
    -> Setzt Änderungen in den Arbeitsdateien zurück, die noch nicht zum Staging-Bereich hinzugefügt wurden.

  ${GREEN}git commit -m message${RESET}
    -> Erstellt einen Commit mit allen Änderungen, die sich im Staging-Bereich befinden, und versieht ihn mit einer Nachricht.

  ${GREEN}git commit -a -m message${RESET}
    -> Fügt alle geänderten und bereits getrackten Dateien automatisch zum Staging-Bereich hinzu und erstellt einen Commit mit Nachricht.

  ${GREEN}git branch${RESET}
    -> zeigt den aktuellen Branch an

  ${GREEN}git branch branch_name${RESET}
    -> erstellt einen neuen lokalen Branch auf dem Commit, auf den der HEAD zeigt

  ${GREEN}git checkout${RESET}
    -> Wechselt den aktuellen Arbeitsstand auf einen anderen Branch, Commit oder Tag.  
      ${CYAN}Branch:${RESET} git checkout branch_name -> Wechselt zu einem anderen Branch.
      ${CYAN}Commit:${RESET} git checkout commit_hash -> Setzt den Arbeitsstand auf einen bestimmten Commit (führt zu einem "detached HEAD").
      ${CYAN}Tag:${RESET}    git checkout tag_name -> Wechselt zu einem bestimmten Tag.

  ${GREEN}git push${RESET}
    -> Überträgt die lokalen Commits des aktuellen Branches auf das Remote-Repository.

  ${GREEN}git push origin --set-upstream branch_name${RESET}
    -> Überträgt den angegebenen lokalen Branch auf das Remote-Repository und richtet ihn als Upstream-Branch ein, sodass zukünftige Pushes und Pulls ohne weitere Angaben möglich sind. Das ist bspw. nötig nach der Erstellung eines neuen lokalen Branches mit git branch branch_name
  ${GREEN}git rm -rf --cached folder/file
    -> Entfernt eine Datei oder einen Ordner aus dem Tracking von git (löscht nicht)
  ${GREEN}git filter-repo --path datei.txt --invert-paths
    -> löscht die Datei aus allen commits (Achtung! D.h. die Historie wird neu geschrieben, es muss mit force-push gepusht werden und das Repository muss neu geklont werden, daher Vorsicht!)

${BOLD}Information & Historie:${RESET}
  ${GREEN}git log --graph --oneline${RESET}
    -> Zeigt die Commit-Historie als kompakten Graphen mit einer Zeile pro Commit.
  ${GREEN}git log --graph --oneline --all${RESET}
    -> Zeigt die Commit-Historie als kompakte Darstellung aller Branches.

${BOLD}Zurücksetzen:${RESET}
  ${GREEN}git reset --soft${RESET}
    -> Setzt den HEAD auf einen früheren Commit zurück, behält aber alle Änderungen im Staging-Bereich.
  ${GREEN}git reset --hard${RESET}
    -> Setzt den HEAD auf einen früheren Commit zurück und verwirft alle Änderungen im Arbeitsverzeichnis und Staging-Bereich.

${BOLD}Zusammenführen:${RESET}
  ${GREEN}git merge branch_name${RESET}
    -> Führt den angegebenen Branch in den aktuellen Branch zusammen.
  ${GREEN}git merge --no-ff branch_name${RESET}
    -> Erstellt immer einen Merge-Commit, auch wenn ein Fast-Forward möglich wäre.
  ${GREEN}git rebase branch_name${RESET}
    -> Überträgt die Commits des aktuellen Branches auf den neuesten Stand des angegebenen Branches.
  ${GREEN}git cherry-pick commit_hash${RESET}
    -> Übernimmt einen bestimmten Commit aus einem anderen Branch in den aktuellen Branch.
  ${GREEN}git mergetool${RESET}
    -> Startet ein Tool zur Unterstützung bei der Lösung von Merge-Konflikten.
  ${GREEN}git diff${RESET}
    -> Zeigt Unterschiede zwischen Dateien, Commits oder Branches, hilfreich bei Konfliktlösung.
EOF
}

# Function to show git aliases
show_git_aliases() {
    echo "🔧 Git Aliases:"
    echo "==============="
    alias | grep '^g[a-z]*=' | sort | while read line; do
        alias_name=$(echo "$line" | cut -d'=' -f1)
        alias_command=$(echo "$line" | cut -d'=' -f2- | sed "s/^'//" | sed "s/'$//")
        printf "%-8s -> %s\n" "$alias_name" "$alias_command"
    done
    echo ""
    echo "💡 Usage: Type any alias name to run the command"
}
