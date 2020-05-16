set -e

DIR=$(mktemp -d '/tmp/helm.XXXXXXX')
OUTDIR="$DIR/out"
mkdir -p $OUTDIR

# Write the input from stdin out as files, and as one file so it can
# be examined for functionConfig.
tee $DIR/input.yaml | kpt --stack-trace fn sink "$OUTDIR"

CONFIG="$DIR/config.yaml"
# Get functionConfig, if any, and extract some values from it.
yq read $DIR/input.yaml 'functionConfig' > "$CONFIG"

releasename=$(yq read "$CONFIG" 'data.releaseName')
namespace=$(yq read "$CONFIG" 'data.namespace')

# Generate the chart. Piping it through `kpt fn source` standardises
# the file paths based on the names.
helm template "${releasename}" ./*.tgz \
     --namespace "${namespace}" \
    | kpt fn source | kpt fn sink "$OUTDIR"
# Write the resulting files back out on stdout
kpt --stack-trace fn source "$OUTDIR"
