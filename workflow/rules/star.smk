rule star:
    input:
        reads=lambda wildcards: get_paired_reads(wildcards),
        star_index="results/star/{genome}_index".format(
            genome=config["ref"]["ncbi_genome_accession"]
        ),
    output:
        multiext(
            "results/star/",
            "{sample}_{unit}_Aligned.sortedByCoord.out.bam",
            "{sample}_{unit}_Log.final.out",
            "{sample}_{unit}_Log.out",
            "{sample}_{unit}_Log.progress.out",
            "{sample}_{unit}_SJ.out.tab",
        ),
    log:
        "logs/star/star_{sample}_{unit}.log",
    params:
        outSAMtype=config["params"]["star"]["outSAMtype"],
        outSAMunmapped=config["params"]["star"]["outSAMunmapped"],
        outSAMattributes=config["params"]["star"]["outSAMattributes"],
        readFilesCommand=config["params"]["star"]["readFilesCommand"],
        outFilterMultimapNmax=config["params"]["star"]["outFilterMultimapNmax"],
        outFilterScoreMinOverLread=config["params"]["star"][
            "outFilterScoreMinOverLread"
        ],
        outFilterMatchNminOverLread=config["params"]["star"][
            "outFilterMatchNminOverLread"
        ],
        alignIntronMin=config["params"]["star"]["alignIntronMin"],
        alignIntronMax=config["params"]["star"]["alignIntronMax"],
        extra=config["params"]["star"]["extra"],
    threads: 12
    conda:
        "../envs/star.yaml"
    shell:
        """
        set -x # activate debugging
        (STAR --runThreadN {threads} \
        --genomeDir {input.star_index} \
        --readFilesIn {input.reads[0]['fq1']} {input.reads[0]['fq2']} \
        --outFileNamePrefix results/star/{sample}_{unit}_ \
        --outSAMtype {params.outSAMtype} \
        --outSAMunmapped {params.outSAMunmapped} \
        --outSAMattributes {params.outSAMattributes} \
        --readFilesCommand {params.readFilesCommand} \
        --outFilterMultimapNmax {params.outFilterMultimapNmax} \
        --outFilterScoreMinOverLread {params.outFilterScoreMinOverLread} \
        --outFilterMatchNminOverLread {params.outFilterMatchNminOverLread} \
        --alignIntronMin {params.alignIntronMin} \
        --alignIntronMax {params.alignIntronMax} \
        {params.extra}) &> {log}
        set -x # deactivate debugging
        """
