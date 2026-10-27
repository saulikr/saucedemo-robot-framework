#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
run_id="$timestamp"
sequence=2
while [[ -e "results/$run_id" ]]; do
    run_id="${timestamp}_$sequence"
    sequence=$((sequence + 1))
done

run_dir="$PWD/results/$run_id"
mkdir -p "$run_dir/reports" "$run_dir/pdf"
printf 'Saving this run to: results/%s\n' "$run_id"

python -m robot \
    --outputdir "$run_dir/reports" \
    --output "output-$run_id.xml" \
    --log "log-$run_id.html" \
    --report "report-$run_id.html" \
    --variable "RUN_ID:$run_id" \
    --variable "RUN_DIR:$run_dir" \
    --variable "HEADLESS:${HEADLESS:-True}" \
    tests/
