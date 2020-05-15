set -e

DIR=$(mktemp -d '/tmp/helm.XXXXXXX')

# Write the input from stdin out as files
kpt --stack-trace fn sink "$DIR"
# Generate the chart. Piping it through `kpt fn source` standardises
# the file paths based on the names.
helm template --generate-name ./*.tgz | kpt fn source | kpt fn sink "$DIR"
# Write the resulting files back out on stdout
kpt --stack-trace fn source "$DIR"
