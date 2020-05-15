set -e

DIR=$(mktemp -d '/tmp/helm.XXXXXXX')

# Write the input from stdin out as files
kpt --stack-trace fn sink "$DIR"
# Generate the chart
helm template --generate-name --output-dir="${DIR}" ./*.tgz >/dev/null
# Write the resulting files back out on stdout
kpt --stack-trace fn source "$DIR"
