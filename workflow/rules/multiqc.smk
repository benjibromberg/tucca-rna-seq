rule multiqc:
    input:
        fastqc_zip="results/fastqc/*zip",
        star_log_final="results/star/*Log.final.out",
        qualimap="results/qualimap/*",
        salmon="results/salmon/*salmon",
    output:
        "results/multiqc/{report_name}.html".format(
            report_name=config["params"]["multiqc"]["report_name"]
        ),
        directory("results/multiqc/multiqc_report_rnaseq_data"),
    params:
        report_name=config["params"]["multiqc"]["report_name"],
        overwrite_existing=config["params"]["multiqc"]["overwrite_existing"],
        extra=config["params"]["multiqc"]["extra"],
    conda:
        "../envs/multiqc.yaml"
    log:
        "logs/multiqc/multiqc.log",
    message:
        "Compiling MultiQC report summary"
    shell:
        """
        unset DISPLAY

        (multiqc -n {report_name} \
        -o results/multiqc/ \
        {params.overwrite_existing} \
        -c config/multiqc_config.yaml \
        {input.fastqc_zip} \
        {input.star_log_final} \
        {input.qualimap} \
        {input.salmon}) &> {log}
        """
