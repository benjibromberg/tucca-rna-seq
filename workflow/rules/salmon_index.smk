rule salmon_index:
    input:
        sequences="assembly/transcriptome.fasta",
    output:
        multiext(
            "salmon/transcriptome_index/",
            "complete_ref_lens.bin",
            "ctable.bin",
            "ctg_offsets.bin",
            "duplicate_clusters.tsv",
            "info.json",
            "mphf.bin",
            "pos.bin",
            "pre_indexing.log",
            "rank.bin",
            "refAccumLengths.bin",
            "ref_indexing.log",
            "reflengths.bin",
            "refseq.bin",
            "seq.bin",
            "versionInfo.json",
        ),
    log:
        "logs/salmon/transcriptome_index.log",
    threads: 2
    conda:
        "envs/salmon.yaml"
    params:
        # optional parameters
        extra="",
    wrapper:
        "v3.10.2/bio/salmon/index"
