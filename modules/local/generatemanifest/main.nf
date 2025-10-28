process GENERATEMANIFEST {
    tag "$meta.id"
    label 'process_single'

    container "community.wave.seqera.io/library/pip_assembly-uploader:7e9461afbdd7a521"

    input:
    tuple val(meta), path(assembly_fasta), path(data_csv)
    val(assembly_study)

    output:
    tuple val(meta), path("results_upload/*.manifest") , emit: manifest
    path "versions.yml"                                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    assembly_manifest \\
        --study results \\
        --data ${data_csv} \\
        --assembly_study ${assembly_study} \\
        ${args}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version)
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir results_upload/
    touch results_upload/test.manifest

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version)
    END_VERSIONS
    """
}
