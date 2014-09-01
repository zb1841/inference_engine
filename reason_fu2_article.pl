#!/usr/bin/perl

#支持 自然语言事实输入 数量不限
my $qc_path="/home/lzj/shell2/client_qc.pl";
use IO::Socket::INET;
use Socket;
use IO::Handle;
use IO::Select;
use IO::Socket::INET;
use IO::Socket;
use Encode;
use Set::Scalar;
use Smart::Comments;
use Clone qw(clone);
#use Data::Dumper;
# 规则  事实 输出
use Socket;
use IO::Handle;
use constant DEFAULT_ADDR => '127.0.0.1';
use constant PORT         => 11221;
use constant IPPROTO_TCP => 6;

my $address =  DEFAULT_ADDR;
my $packed_addr = inet_aton($address);
my $destination = sockaddr_in(PORT,$packed_addr);
my $a1=$ARGV[0];
my $a2=$ARGV[1];
my $a3=$ARGV[2];
my $ptmp;
my $no_vec=0;
my $no_seg=0;

socket(SOCK,PF_INET,SOCK_STREAM,IPPROTO_TCP) or die "Socket err:$!";
connect(SOCK,$destination) or $no_vec=1;
#print "no vector server:$! \n";
SOCK->autoflush(1);

use constant DEFAULT_ADDR2 => '127.0.0.1';
use constant PORT2         => 11222;
use constant IPPROTO_TCP2 => 6;

my $address2 =  DEFAULT_ADDR2;
my $packed_addr2 = inet_aton($address2);
my $destination2 = sockaddr_in(PORT2,$packed_addr2);


socket(SOCK2,PF_INET,SOCK_STREAM,IPPROTO_TCP2) or die "Socket err:$!";
connect(SOCK2,$destination2) or  $no_seg=1;
SOCK2->autoflush(1);
#$cc=_isnoun("大象");
#print "$cc n大象\n";
#$cd=_isnoun("飞");
#print "$cd n飞\n";

#$cc=_isverb("大象");
#print "$cc v大象\n";
#sleep 1;
#$cd=_isverb("飞");
#print "$cd v飞\n";
#sleep 1;
#$cd=_isverb("联系");
#print "$cd v联系\n";
#sleep 1;
#$cd=_isverb("吃");
#print "$cd v吃\n";
#$c=_gt("七十六","二百五十三");
#print $c,"\n";
#exit;







open(FD,"$ARGV[0]");
open(FDout,">$ARGV[2]");
#rule file
my $totalok=0;
my $n=0;
my $tj;
my @tj;
our @samelist;
our  $hashxsj;
our @uniqlist;
my $hash;
my $xiansuoji;
my $tj_p;
my $resr;
my $resl;
my $nn=0;
#线索集 一一对应  条件集tj 后 验证 same 和uniq
our @rulabc;
our @resabc;
our  @yueshu;
while(<FD>)
{

#{ ?x 喜欢 ?y . ?y 属于 ?z } => { ?x 喜欢 ?z }
#{ $a1 喜欢 $a2 && $a2 属于 $a3 } => { $a1 喜欢 $a3 }
#{ $a1 喜欢 $a2 && $a2 属于 $a3 && $a3 可能是 $a4 } => { $a1 喜欢 $a4 }
# if $r1 =~\$  $r2 != "喜欢" $r3 == $n2

$line=$_;
chomp($line);
        @liftright=split("=>",$line);
my $var_list;
my $free_var;
my $same_var;
my $same_list;
my $path_list;
my @path_list;
my $m=0;

if($liftright[0]=~/(.*?)\|(.*)/)
{
$liftright[0]=$1;
my $yueshu_str=$2;
my @tmpat=split("&&",$yueshu_str);
$yueshu[$nn]=clone(\@tmpat);
## $yueshu

}
else
{
}


        @liftp=split("&&",$liftright[0]);
$rulabc[$nn]=clone(\@liftp);
## @rulabc
$nn++;
my $ntr=0;
$resl[$n]=$liftright[0];
$ptmp[$n] =1;
if($liftright[1]=~/(.*)\|(.*)/)
{
 $ptmp[$n] =$2;
$resr[$n]=$1;
}
else
{
$resr[$n]=$liftright[1];
}
        $n++;

}
$rand=rand();

if($no_seg ==1)
{
system("cp $ARGV[1] /tmp/$rand");
}

else
{
if(!-e "$ARGV[1]")
{
my @af=`cat  /home/lzj/fuxi/test/$ARGV[1]`;
my $s=join("",@af);
my @tmp_sen = split /\.|。|;|；|\?|？|!|！|，/, $s;
open(FDt,">/tmp/$rand-");
foreach my $t  (@tmp_sen)
{
        print FDt "$t\n";
}
close FDt;

system("$qc_path  /tmp/$rand-  /tmp/$rand");
}
else
{

my @af=`cat $ARGV[1]`;
my $s=join("",@af);
my @tmp_sen = split /\.|。|;|；|\?|？|!|！|，/, $s;
open(FDt,">/tmp/$rand-");
foreach my $t  (@tmp_sen)
{
        print FDt "$t\n";
}
close FDt;




$c=`$qc_path /tmp/$rand- /tmp/$rand`;
#print "$qc_path $ARGV[1] /tmp/$rand 111111111111111111111111\n";
}
#print ("$qc_path $ARGV[1] /tmp/$rand 222222222222222\n");
system("cp /tmp/$rand /tmp/33");
}
#open(FDlog,">/tmp/res.log");

#print FDlog "/home/lzj/shell2/client_qc.pl /home/lzj/fuxi/test/$ARGV[1]  /tmp/$rand\n";
#close FDlog;
open(FD,"/tmp/$rand");
#rule file
my $n=0;
#my $tj;
my $nn=0;
my $xsjtmpid=0;
while(<FD>)


{
        my $line=$_;
chomp($line);
  @abc=split(" ",$line);
my $toabc=scalar(@abc);
my $pftmp=1;
if($abc[$toabc-1]=~/^\|(.*)/)
{
$pftmp=$1;
pop(@abc);
my $tjp=join(" ",@abc);
$tj_p->{$tjp}=$pftmp;
}
else
{
my $tjp=join(" ",@abc);
$tj_p->{$tjp}=$pftmp;
}
$resabc[$nn]=clone(\@abc);
$nn++;
}
unlink("/tmp/$rand");
## @resabc
#if(exists($hash->{$abc[1]}))

#(my ($k6,$v6)=each($hash->{$abc[1]}))

#       addmorexs(\@abc,$_);
        my $tn1=$_;
  our @xsj=();
our $xsj=();
        for(0 ..scalar(@rulabc)-1)
        {
                my      $loopn=0;
                my $abcn=$_;
                 @xsj=();
                 @xsss=();
                 $xsss=();
                 $xsj=();
                our $xsjtmp=0;
                my $xsjtmpid=0;
                our $xsjset=();
                our @xsjset=();
                                                                        
                                                                                        for(0 .. scalar(@{$rulabc[$abcn]})-1)
                {
                        my $nnn=$_;
                my @efg=split(" ",$rulabc[$abcn][$nnn]);
                my $hasone=0;
                for(0 .. scalar(@resabc)-1)
                {
                        my $inp=$_;
## @efg
#print "@{$resabc[$inp]}    @efg\n";
## @yueshu
#print "inp $inp \n";
## @yueshu
                $xsjtmp=match_2_ex(\@{$resabc[$inp]},\@efg,\@{$yueshu[$abcn]});
## $xsjtmp
                if($xsjtmp==0){next;}
                #if($xsjtmp==0){next;}
                else
                {
                $xsjset[$xsjtmpid]=clone($xsjtmp);
# 如果xsjset中是 数组，则匹配变量，否则是常量
#               if(exists($hashxsj->{$resabc[$inp]}))
#               {
#                               $xsjtmpid=$hashxsj->{$resabc[$inp]};
#                               push (@{$xsj[$loopn]},$xsjtmpid);
#print "efg @efg ----这个线索满足规则第$loopn 段  重用  xsid=$xsjtmpid\n";
#               }else
#                       {
#                               $hashxsj->{$resabc[$inp]}=$xsjtmpid;

#print "efg @efg ----这个线索满足规则第$loopn 段    xsid=$xsjtmpid\n";
                                push (@{$xsj[$loopn]},$xsjtmpid);
                                push (@{$xsss[$loopn]},join(" ",@{$resabc[$inp]}));
                                $xsjtmpid++;
#                       }
                        }
                }

                $loopn++;

                }
##  @xsj

                tjjg($abcn);
        }
#  @xsjset

                #if(scalar(@xsj)<)
sub tjjg
{
        my $abcn=$_[0];
        my $resn=scalar(@xsj);
## @xsj
## @xsjset
        my $resno=scalar(@{$rulabc[$abcn]});
        my $big2=();
        my @big2=();
        my @members;

#print "$resno--$resn-\n";

                my $narr;
                my @narr;
                my $tmpbig=2;
                if ($resn<$resno)
                {

                #print "第$abcn条规则 $resn $resno 条件不足跳过\n";
## @xsj
## @{$rulabc[$abcn]}
                return 0;
                }
                else
                {
#print "满足规则所有条件尝试求解\n";
                for(0 .. (scalar(@xsj)-1))
                {
                        my $bn=$_;
#print "笛卡尔循环 $bn 共 $resn次\n";
#                       $big[$bn]=Set::Scalar->new($xsj[$bn]);
                        if($tmpbig==2)
                        {

$tmpbig=Set::Scalar->new(@{$xsj[$bn]});}
                        else
                        {
                        $tmpbig=Set::Scalar->new(@{$narr});
                        $narr=();
## $tmpbig
                        }

                        my $big2=Set::Scalar->new(@{$xsj[$bn+1]});
                         my $c = $tmpbig->cartesian_product($big2);
                        $tmpbig=$c->copy;
                        @members  = $tmpbig->members;
                        $tmpbig=();
                for(0.. scalar(@members)-1)
                {
                        my $t9=$_;
                        $str=join(" ",@{$members[$t9]});
#print "str $str\n";
                        push (@{$narr},$str);
                }
                }


#               if(scalar(@members)==0)
#               {
#               $members[0]=clone($xsj[0]);
#               }
## $narr
#               $tmpbig=clone(@narr);
#每个元素是一个解
                for(0 .. scalar(@{$narr})-1)
                #for(0 .. scalar(@members)-1)
                {
                        my $tmm=$_;
                       $mublhash=mubl(\@{$rulabc[$abcn]},\@{$members[$tmm]});
#print "mub --$mublhash--\n";
                        if($mublhash ==-1){
                #print "00000000000000\n";
                next;}

#可能解
## $mublhash
##$tmm 可能解
#继续验证可能解
# $mublhash= $a->{$线索组id}->{解数组}
# $mublhash= $a->{$线索组id2}->{解数组}
# $mublhash= $b->{$线索组id}->{解数组}
# $mublhash= $b->{$线索组id2}->{解数组}
                        if($mublhash==0)
                        {
                                #print "完全常量,条件成立\n";
                                print FDout "$resr[$abcn]\n";
                                next;
                        }
                        $jres=check_mu_res($mublhash,$tmm);
                if($jres==0)
                {
                next;
                        }
                else
                {
                        #print "第$abcn条规则成立 @{$rulabc[$abcn]}    $resr[$abcn]\n";
## $jres
## @resr
## $c
#print "aaaaaaaaaaa".$jres[0]->{\$a}"\n";
                while(my($k78,$v78)=each($jres))
                {
                        my $jck=$k78;

                   my @cres=split(" ",$resr[$abcn]);

                        foreach my $nnc (@cres)
                        {
                                if ($nnc=~/\$/)
                                {

                                                print FDout $jres->{$jck}->{$nnc}," ";
                                }
                                else
                                {
                                print FDout "$nnc ";
                                }
                        }
                        print FDout "\n";
                }
                }
#                       $jres=check_un_res($mublhash);


                }
             }
}

##
## @tj
## start
## $xiansuoji
#               $tatoal1=tl(\@abc,$k);
        #       if($$tatoal1 < )
        #{}
#my $tatoal2=sa("河马 喜欢 大象 小象 可能是 大象 小象 属于 幼崽 小象 可能是 大象",1);
#my $tatoal2=sa("河马 喜欢 大象 小象 可能是 大象 小象 属于 幼崽 幼崽 可能是 小动物",1);
#print "sa res=$tatoal2\n";
##my $tatoal3=un("河马 喜欢 大象 小象 可能是 大象 小象 属于 幼崽 幼崽 可能是 小动物",1);
#else
#{next;}
#}




sub tl
{
        my $nn=$_[1];
#print "nn  $_[0][0] $_[0][1] $_[0][2] --- $_[1]\n";


}



sub sa
{
        my $pas=$_[0];
        my $n=$_[1];
my @apas2=split("#",$pas);
my $pshash={};
for(0 ..scalar(@apas2)-1)
{
        my $kk=$_;
my @tarr=split(" ",$apas2[$kk]);
        for(0 .. scalar(@tarr)-1)
        {
        my $ww=$_;
        $pshash->{$kk}->{$ww}=$tarr[$ww];
#print"生成 序列  $pshash->{$kk}->{$ww} $kk $ww\n";
        }
}
#print "start sa  $n @apas\n";
# push (@{$samelist[$n]->{$k}},$path_list->{$k}[$np]);
                my $ctmp;
my $res="ok";
## @samelist
if(exists($samelist[$n]))
{
#print "发现数组 sa\n";

}
else
{
#print "严重 没发现sa\n";
}
for(0 .. scalar(@{$samelist[$n]})-1)
{
                my $ccn=$_;
                my $ctmp;
                $rn=0;
                foreach my $c(@{$samelist[$n][$ccn]})
                {
                                my $zj,$lr;
                        if($c=~/(.*?) (.*)/)
                        { $zj=$1;
                         $lr=$2;
                        }
#print "相同变量中 第$n行 的一个 在位置 \n";
                        #print "位置 $zj $lr \n";
                        if($rn==0)
                        {
                        $ctmp=$pshash->{$zj}->{$lr};
                        #$ctmp=$apas[$zj*3+$lr];
                                $rn=1;
                                next;
                        }
                        elsif($ctmp eq $pshash->{$zj}->{$lr})
                        {
                        #       $resn++;
                        }
                        else{
                                $res="bad";
                                #print "wrong--- ctmp=$ctmp apas=".$pshash->{$zj}->{$lr} ."----@apas2--------------------\n";
                                return $ctmp;
                                #last;
                        }
                                #print "org $ctmp ".$pshash->{$zj}->{$lr}."\n";


                }

}


        if($res eq "ok")
        {$res="ok";
#print "find same ok\n";
}
return $res;


}

sub un
{
my $pas=$_[0];
        my $n=$_[1];
        my $pas2=$_[2];
my @apas2=split("#",$pas);
#print "un 输入参数 ------------#$pas#$n\n";
my $pshash={};
my @pshash2;
for(0 .. scalar(@apas2)-1)
{
        my $kk=$_;
my @tarr=split(" ",$apas2[$kk]);
        for(0 .. scalar(@tarr)-1)
        {
        my $ww=$_;
        $pshash->{$kk}->{$ww}=$tarr[$ww];
#print "kkww $kk $ww $tarr[$ww]\n";
        if($tj[$n][$kk][$ww]->{"type"} eq "c")
                {
                push (@pshash2," ");
                next;}
                else
                {
                push (@pshash2,$tarr[$ww]);
                }
        }
}


my $res;
my $rn=0;
## @uniqlist
if(exists($uniqlist[$n]))
{
#print "发现数组 un\n";

}
else
{
#print "没发现un\n";
return "ok";
}
for (0 .. scalar(@{$uniqlist[$n]})-1)
{

                my $iii=$_;
                foreach my $c(@{$uniqlist[$n][$iii]})
                {

                my $wz=$_;
        #print "唯一集合中 第$n行  位置是$c\n";
                 $c=~/(.*?) (.*)/;
                         my $zj=$1;
                        my $lr=$2;
                my $ctmp;
                        $ctmp=$pshash->{$zj}->{$lr};
                        #$ctmp=$apas[$zj*3+$lr];
#               $ctmp=$apas[$wz];
        #print "un--$c--$ctmp--------$zj-$lr--v \n";
#   push (@{$uniqlist[$n]->{$k}},$path_list->{$k}[$np]);


                $rn=0;
                        for(0 .. scalar(@pshash2)-1)
                        {
                                my $ggn=$_;
                                #print "un ctmp $ctmp $pshash2[$ggn]\n";
                        if($ctmp eq $pshash2[$ggn])
                        {
                                $rn++;
                        #print "uniq 发现1个 $ctmp 目前 位置$ggn\n";

#                               print "type ".$tj[$n][$zj][$lr]->{"type"}."\n";

                        }
                        if($rn>=2){
                                $res=$ctmp;
                                #print "un wrong--- ctmp=$ctmp -@apas--------------------\n";
                                return $ctmp;
                        }
#                                print "org $ctmp ".$apas[$zj*3+$lr]."\n";
                        }
                }


}
#$res=$rn;
if($rn==1){$res="ok";};
#print "unres $res\n";
return $res;



}

sub fm
{
my $word=$_[0];
my $dist=$_[1];
my $type=$_[2];
my $tmpfile;
my $ares=0;
my $i;
if($type eq "qc")
{

#my $a="0 ".seg_txt($word);
#my $b="1 ".seg_txt($dist);

# print SOCK "dist $a $b\n";
#                if ($i=<SOCK>)
#                {
#                       print "$i socket\n";
#                }
#my $res=0;
#if($i=~/0-1-(\d\.\d\d\d\d\d)/)
#{
#        $ares=$1;
#}
#else{$ares=0;}



 print SOCK "dist_seg $word $dist qc\n";
# print "dist_seg $word $dist qc\n";
                if ($i=<SOCK>)
                {
             #          print "0000000000000000000\n";
             #          print "$i socket\n";
                }
if($i=~/0-1-(\d\.\d\d\d\d\d).*/)
{
        $ares=$1;
}
else{$ares=0;}

#print $res."   666666666666\n";
}
else
{
                print SOCK "dist $word $dist\n";
                if ($i=<SOCK>)
                {
#                       print "$i socket\n";
                }
my $res=0;
if($i=~/0-1-(\d\.\d\d\d\d\d)/)
{
        $ares=$1;
}
else{$ares=0;}
}
#print "-start--------fm start-$ares---$word--$dist-$type type----\n";


$ares;
}
sub seg_txt
{
my $txt=$_[0];
 print SOCK2 "$txt 1 1\n";
#print "分词 $txt\n";
                if ($i=<SOCK2>)
                {
#                       print "$i socket\n";
                }
                }
my $res=0;
chomp($i);
$i;

}
sub match_2_ex
{
my @res;
    my $input=$_[0];
    my @input1=@{$input};
    my $input2=$_[1];
    my @input2=@{$input2};
    my $input3=$_[2];
    my @input3=@{$input3};
## @input1;
## @input2;
## @input3;
my $md;
        my $lena=scalar(@input1);
        my $lenb=scalar(@input2);
        my $now_set=0;
my $mdv;
my      $lastv=0;
        if($lena<$lenb)
        {
#print "0\n";
return 0;}
        for(0 .. ($lenb-1))
        {
                my $cl=$_;
                my $have=0;
                for($now_set ..($lena-1))
                {
                        my $sl=$_;
                        if($input2[$cl]=~/\$/)
                        {       $have=1;
                                $md[$cl]="null";
                                 last;}

                        elsif($input2[$cl] eq $input1[$sl] )
                        {
                                $md[$cl]=$sl;
 $lastv=$sl;
                                $now_set=$sl+1;
                                $mdv->{$sl}=$cl;
                                $have=1;
                                last;
                        }
                        elsif($input2[$cl]=~/(.*?)\~(.*)/)
                        {
                                my $a1=$1;
                                my $a2=$2;
                                 my $fn=0;
                                 my $fn=fm($a1,$input1[$sl],"qc");
                                 if($fn>$a2)
                                {
                                $md[$cl]=$sl;
                                $lastv=$sl;
                                $mdv->{$sl}=1;
                                $now_set=$sl+1;
                                $have=1;
                                last;
                                }
                        }

                }
        if($have==0){return 0;;}

        }
                my $tmax=0;
                my $tmin=0;
                my $max=$lena;
                $md[$lenb]=$lena;
                my $min=0;
        for(0 .. ($lenb-1))
        {
                        my $cl=$_;
                if($input2[$cl]=~/\$(.*)/)
                {
                        my $now_bl=$1;
                                        for(1 ..$cl)
                                        {       my $now=$_;
                                                                     if($md[$cl-$now]>0)
                                                        {$min=$md[$cl-$now];last;}


                                        }
#
                                        for(($cl+1) ..(scalar(@md)-1))
                                        {
                                                my $now=$_;
                                                if($md[$now] >0)
                                                {$max=$md[$now];;last;}
                                        }


                                        for($min .. $max-1)
                                        {
                                        my $nr=$_;
                                        if(exists($mdv->{$nr}))
                                                {

#print "发现锚点$nr 跳过\n";
                                                next;}
#                                               if($nr==0)
#                                               {

#                                               }
#print "input1[$nr],$now_bl,@input3\n";
                                                if(scalar(@input3)>=1)
                                                {
                                                if(match_yueshu($input1[$nr],$now_bl,\@input3))
                                                {
                                                push(@{$res[$cl]},$input1[$nr]);
                                                }
                                                }
                                                else
                                                {push(@{$res[$cl]},$input1[$nr]);}
 }
        #                               print "$res[$cl],$min,$max\n";

                }
                else

                {
                        $res[$cl]=$input1[$md[$cl]];
        #print "常量 $input1[$md[$cl]]\n";
                }


        }

## @res
\@res;

}
sub mubl
{
my $mres;
my %mres;
    my $input=$_[0];
    my @inputa=@{$input};
    my $input1=$_[1];
    my @inputb=@{$input1};
## @inputa: [
##            '天空 下雨 $e ',
##            ' $d 在家 ',
##            ' $a 下班了 ',
##            ' $a 是 主人 ',
##            ' $a $c $d 吃饭'
##          ]

## @inputb: [
##            '0 1 3 5',
##            '6'
##          ]

# $mublhash= $a->{$线索组id}->{解数组}
# $mublhash= $a->{$线索组id2}->{解数组}
# $mublhash= $b->{$线索组id}->{解数组}
 $mublhash= $b->{$线索组id}->{解数组}
# $mublhash= $b->{$线索组id2}->{解数组}
my $inpb;
 $inpb=$inputb[0]." ".$inputb[1];
my @arrb=split(" ",$inpb);
##  @inputa
## @inputb
## @arrb
#print "liangzuuuuuuuuuuuuuuuuuuua ",scalar(@arrb) ,"   " ,scalar(@inputa),"\n";
if((scalar(@arrb) != scalar(@inputa) )||(scalar(@arrb)==0))
{
#print "线索不完整，不够规则数量\n";
return -1;}
my $isb=0;
for(0 .. scalar(@inputa)-1)
{
        my $now_id=$_;
        my @j17=split(" ",$inputa[$now_id]);
## @j17
                for(0 .. scalar(@j17)-1)
                {
                        my $nnid=$_;
                        if($j17[$nnid]=~/\$/)
                        {
                        #for(0 .. scalar(@{$xsj[$nnid]})-1)
                        #{
                        #       my $jcx=$_;
                                #my @jj=split(" ",$xsss[$nnid][$jcx]);

                        #print "$j17[$nnid] ---$nnid-  线索段id $now_id-17\n";
                        #print "$j17[$nnid] ---$nnid-$xsss[$nnid][$jcx]-17\n";

                        #print "$j17[$nnid] ---$nnid-$xsj[$nnid]-17\n";
## @xsj
## @xsjset
                        $mres->{$j17[$nnid]}->{$arrb[$now_id]}=$xsjset[$arrb[$now_id]][$nnid];
                        #}
                        $isb++;
                        }
                }
}
if($isb==0)
{return (0);}

 return (\%{$mres});

}
sub check_mu_res
{
#求变量交集合
#成功返回1
#check_mu_res
## $mublhash: {
##              '$a' => {
##                        '3' => [
##                                 '小明',
##                                 '快要'
##                               ],
##                        '5' => [
##                                 '小李',
##                                 '小王'
##                               ]
##                      },
##              '$d' => {
##                        '1' => [
##                                 '小李',
##                                 '小红'
##                               ],
##                        '6' => [
#                                 '小明',
##                                 '防盗监控',
##                                 '发动机声卡'
##                               ]
##                      },
##              '$e' => {
##                        '0' => [
##                                 '哈哈'
##                               ]
##                      }
##            }
my $res;
my $input=$_[0];
my $in2=$_[1];
my %inputa=%{$input};
## %inputa
my $hash_mu_v;
my $hash_un_v;
my $hashv;
my $cfblj;
my $unblj;
        while(my ($k,$v)=each(%inputa))
        {
                my $fz=0;
                while(my ($k1,$v1)=each(%{$v}))
                {
                                $fz++;
                        my $ttmphash;
                        for(0 .. scalar(@{$v1})-1)
                        {
                                my $tv=$_;
                                if(! exists($ttmphash->{@{$v1}[$tv]}))
                                {
                                $hashv->{$k}->{@{$v1}[$tv]}++;
                                $ttmphash->{@{$v1}[$tv]}=1;
                                }

#$hashv->{$a}->{"小明"} =1
#print "---- $k v @{$v1}[$tv]\n";
                        }
                                if($fz>=2)
                                {
                                        $hash_mu_v->{$k}=$fz;
                                }
                }
                        if(exists($hash_mu_v->{$k}))
                        {}else
                                {
                                $hash_un_v->{$k}=1;
                                while(my ($k22,$v22)=each(%{$v}))
                                {
                                $unblj->{$k}=clone($v22);
#print "---22---@{$unblj->{$k}}\n";
                                }
                        }
        }


         while(my ($k,$v)=each(%{$hash_mu_v}))
        {
                                my $youjie=0;
                        while(my ($k1,$v1)=each(%{$hashv->{$k}}))
                        {

                                if(($v1>=$hash_mu_v->{$k})&&($v1>=2))
                                {
                                        $youjie=1;
                                        #print "发现重复变量解 $k $k1,$v1\n";
                                        push(@{$cfblj->{$k}},$k1);
#print "---33-$in2-$k-@{$cfblj->{$k}}\n";
                                }
                        }
                        if($youjie==0)
                        {
#print "不满足重复变量解 $k\n";return 0;
                        }
        }
#检查每个变量的有解
## $cfblj
## $unblj
my $firstv==1;
                my $tmpbig2;
                my $tmpbigo;
                my $tmpt;
my      $ttt;
my $cccc;
my @cccc;
my $ne=-1;

while(my ($k9,$v9)=each(%{$unblj}))
{
my $tmpv;
my @tmpv;
                                       foreach my $mt(@{$v9})
                       {
                               push (@tmpv,"$k9 $mt");
                       }
## @tmpv
                if($ne==-1)
                {
        $cccc1=Set::Scalar->new(@tmpv);
        $ne++;
                }
                else{
        $cccc[$ne]=Set::Scalar->new(@tmpv);
        $ne++;
                }
}
while(my ($k9,$v9)=each(%{$cfblj}))
{
my $tmpv;
my @tmpv;
                                       foreach my $mt(@{$v9})
                       {
                               push (@tmpv,"$k9 $mt");
                       }
## @tmpv
                        if($ne==-1)
                {
        $cccc1=Set::Scalar->new(@tmpv);
        $ne++;
                }
                else{
                                                              $cccc[$ne]=Set::Scalar->new(@tmpv);
        $ne++;
}
}
my $ccc=Set::Scalar->new();
## @cccc
 my $c = $cccc1->cartesian_product(@cccc);


my @a=$c->members;
my $jj=0;
foreach my $b (@a)
{

my $lcv;
my $ch=0;
my $jk;
#print "-------------------$ne--\n";

        foreach my $c (@{$b})
        {
                my ($k,$v)=split(" " ,$c);
                #print "$k---$v     $c\n";
                $jk->{$k}=$v;
                if(exists($lcv->{$v}))
                {
                        $ch=1;
                }
                else
                {
                        $lcv->{$v}=1;
                }

        }
        if($ch==1)
        {
                #print " 变量重合解@{$b}\n";
        }

        else
                                                          {
                #print " 严格解@{$b}\n";
                $res->{$jj}=clone($jk);
                $jj++;
        }
}

return (\%{$res});
}



sub _isnum
{
my $a=$_[0];
if($a=~/\d+/)
{return 1;}
#/mnt/sdb/shell2/chnumtoa.py  八十二
my $c=`./chnumtoa.py  $a`;
        if($c=~/^\d+/)
                {
        return 1;
        }
return 0;

}
sub _isnoun
{
my $txt=$_[0];
my $socket = IO::Socket::INET->new(
                                         PeerAddr => "127.0.0.1",
                                         PeerPort => "11222",
                                         Type => SOCK_STREAM,
                                         Proto => "tcp",
                                       )
       or die "Can not create socket connect.$@";
    $socket->autoflush(1);

 $sel = IO::Select->new($socket);
    $socket->send("$txt 1 pos\n",0);  ##发送消息至服务器端。
#print "分词 $txt\n";
my $i;
                       #print "$i socket\n";
    while (my @ready = $sel->can_read) {    ##等待服务端返回的消息
            foreach my $fh (@ready) {
                if ($fh == $socket) {
                    while (<$fh>) {
                      $i=$_;
#print "read====$i==================\n";
                    }
                    $sel->remove($fh);
                    close $fh;
                }
                }
                }
        if ($i=~/\/n/)
        {return 1;}
        else {return 0;}

}
sub _gt
{
my $a=$_[0];
my $b=$_[1];
        if ((_isnum($a)==1)||(_isnum($b)==1))
        {
        my $aa=_strtonum($a);
        my $bb=_strtonum($b);
                if($aa>$bb)
                {return 1;}
        }
        return 0;



}
sub _isverb
{
my $txt=$_[0];
my $socket = IO::Socket::INET->new(
                                         PeerAddr => "127.0.0.1",
                                         PeerPort => "11222",
                                         Type => SOCK_STREAM,
                                         Proto => "tcp",
                                       )
       or die "Can not create socket connect.$@";
    $socket->autoflush(1);

 $sel = IO::Select->new($socket);
    $socket->send("$txt 1 pos\n",0);  ##发送消息至服务器端。
#print "分词 $txt\n";
my $i;
                       #print "$i socket\n";
    while (my @ready = $sel->can_read) {    ##等待服务端返回的消息
            foreach my $fh (@ready) {
                if ($fh == $socket) {
                    while (<$fh>) {
                      $i=$_;
#print "read====$i==================\n";
                    }
                    $sel->remove($fh);
                    close $fh;
                }
                }
                }
        if ($i=~/\/v /)
        {return 1;}
        else {return 0;}

}
sub _gt
{
my $a=$_[0];
my $b=$_[1];
        if ((_isnum($a)==1)||(_isnum($b)==1))
        {
        my $aa=_strtonum($a);
        my $bb=_strtonum($b);
                if($aa>$bb)
 {return 1;}
        }
        return 0;

}

sub _strtonum
{
my $a=$_[0];
if($a=~/\d+/)
{
return $a;
}
my $b=`./chnumtoa.py  $a`;
$b;


}
sub match_yueshu
{
#@yueshu
my $input1=$_[0];
my $input2=$_[1];
my $inputt=$_[2];
    my @input3=@{$inputt};
#print "-----========";
##不太,vvv, $vvv 名词   $nnn 动词
#print @input3;
        foreach my $cx(@input3)
        {
                my @wlist=split(" ",$cx);
                if ($wlist[0] eq "\$"."$input2")
                {
                        my $pos=_ispos($input1);
#print "pos $input1-$pos-but-$wlist[1]-\n";
                        if($pos eq $wlist[1])
                        {
                                return 1;
                        }
                        else
                        {
                                return 0;
                        }

                }
        }
return 1;

}
sub _ispos
{
my $txt=$_[0];
my $socket = IO::Socket::INET->new(
                                         PeerAddr => "127.0.0.1",
                                         PeerPort => "11222",
                                         Type => SOCK_STREAM,
                                         Proto => "tcp",
                                       )
       or die "Can not create socket connect.$@";
    $socket->autoflush(1);

 $sel = IO::Select->new($socket);
    $socket->send("$txt 1 pos\n",0);  ##发送消息至服务器端。
#print "分词 $txt\n";
my $i;
                       #print "$i socket\n";
    while (my @ready = $sel->can_read) {    ##等待服务端返回的消息
            foreach my $fh (@ready) {
                if ($fh == $socket) {
                    while (<$fh>) {
                      $i=$_;
                    }
                    $sel->remove($fh);
                    close $fh;
                }
                }
                }
chomp($i);
$i=~s/.*?\/(.*?) /$1/g;

        return $i;

}
