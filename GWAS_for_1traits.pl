use strict;
use warnings;


#plink输入vcf一般按照--geno 0.2 --maf 0.05进行过滤
#个体样本量大时,应进行mind 0.02 过滤。都根据数据情况选择
#plink --bfile $plink --mind 0.02 --geno 0.2 --maf 0.05 --make-bed --out cleaned
#缺失率统计
#plink --bfile $plink --missing
#plink输入文件
my $plink=shift;

my $gcta="gcta64";

my $plink_soft="plink";

#plink输入文件要使用beagle进行填充

# 估有效SNP大小的java脚本
my $Me="/data/00/user/user125/software/gec/gec.jar";

system "java -jar $Me -Xmx1g --effect-number --plink-binary $plink --genome --out ./Me-output\n";
#算出来的值要进行-log10base处理

my $ind_snp;
open IN,"<./Me-output.sum"||die "can not found this file!!!";
while(<IN>){
    chomp;
    next if(/Observed_Number/);
    my @a=split/\s+/,$_;
    $ind_snp = $a[1];
    print "$ind_snp\n";
}
close IN;


#生成fastGWA计算准备文件
system "gcta64 --bfile $plink --autosome --maf 0.01 --make-grm --out $plink --thread-num 10\n";
#去掉有亲缘关系的个体，如果是F1自交系则不执行这一步
#system "gcta64 --grm $plink --grm-cutoff 0.025 --make-grm --out $plink\_rm025\n“;
#估计SNP的遗传力
my @phens=`ls ./*phen`;
for my $phen (@phens){
    chomp($phen);
    system "gcta64 --grm $plink --pheno $phen --reml --out $phen --thread-num 10\n";
    #参杂协变量的计算
    #print "gcta64 --grm $plink --pheno $phen --reml --qcovar test_10PCs.txt --out test --thread-num 10\n";
}

system "gcta --bfile $plink --make-grm --out geno_grm --make-grm-alg $alg_type\n";
system "gcta --grm geno_grm --make-bK-sparse 0.05 --out sp_grm\n";

#计算协变量
system "gcta64 --grm $plink --pca 10 --out out_pca"
#生成fastGWA文件 使用MLM计算
for my $phen (@phens){
    chomp($phen);
    system "$gcta --bfile $plink --grm-sparse sp_grm --fastGWA-mlm --pheno $phen --out $phen\n";
    #参杂协变量的计算
    #print "$gcta --bfile $plink --grm-sparse sp_grm --fastGWA-mlm --pheno $phen --qcovar cov_plink.txt --out $phen\n";
}
close IN2;


####SNP位点独立性验证(类似于先验检测)
#生成cojo输入文件
my @fastGWAs=`ls ./*.fastGWA`;
for my $fastGWA (@fastGWAs){
    chomp($fastGWA);
    open IN3,"<$fastGWA"||die "can not found fastGWA!";
    open OUT,">>$fastGWA\.ma"||die "can not found fastGWA.ma!";
    while(<IN3>)
    {chomp;
     my @a=split/\s+/,$_;
     print OUT "$a[1]\t$a[3]\t$a[4]\t$a[6]\t$a[7]\t$a[8]\t$a[5]\n";
    }
}
close IN3;
    
#cojo输入文件
my @cojos=`ls ./*.ma`;
for my $cojo (@cojos){
    chomp($cojo);
    system "$gcta --bfile $plink --maf 0.01 --cojo-file $cojo --cojo-p 1.04E-5 --cojo-collinear 0.1 --cojo-wind 200 --diff-freq 0.2 --cojo-slct --out $cojo\.out\n";
}


