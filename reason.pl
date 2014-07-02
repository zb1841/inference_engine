#!/usr/bin/perl
#use Smart::Comments;
#use Data::Dumper;
#argv0 规则文件 argv1 事实文件  argv2 输出文件
open(FD,"$ARGV[0]");
open(FDout,">$ARGV[2]");
#rule file
my $totalok=0;
my $n=0;
my $tj;
my @tj;
our @samelist;
our @uniqlist;
my $hash;
my $xiansuoji;
my $resr;
my $resl;
#线索集 一一对应  条件集tj 后 验证 same 和uniq
while(<FD>)
{

#{ ?x 喜欢 ?y . ?y 属于 ?z } => { ?x 喜欢 ?z }
#{ $a1 喜欢 $a2 && $a2 属于 $a3 } => { $a1 喜欢 $a3 }
#{ $a1 喜欢 $a2 && $a2 属于 $a3 && $a3 可能是 $a4 } => { $a1 喜欢 $a4 }
# if $r1 =~\$  $r2 != "喜欢" $r3 == $n2

$line=$_;
        @liftright=split("=>",$line);
my $var_list;
my $free_var;
my $same_var;
my $same_list;
my $path_list;
my @path_list;
        @liftp=split("&&",$liftright[0]);
my $m=0;
        foreach $a (@liftp)
        {
                if(length($a)<2){next;}
                @lift=split(" ",$a);
                if ($a=~/\{/){next;}
                if($a=~/\}/){next;}
                if($lift[0] =~/^\$/)
 {
                        $bl=1;
                        print "变量0 $lift[0] \n";;
                                $tj[$n][$m][0]->{"type"}="v";
                                $tj[$n][$m][0]->{"value"}=$lift[0];

                                        $var_list->{$lift[0]}++;
                                        push(@{$path_list->{$lift[0]}},"$m 0");

                }
                elsif(length($lift[0])>1)
                {
                        print "$lift[0] 1常量\n";
                        $bl=0;
                                 $tj[$n][$m][0]->{"type"}="c";
                                $tj[$n][$m][0]->{"value"}=$lift[0];



                }

                if($lift[2] =~/^\$/)
                {
                        print "变量2 $lift[2] $m 2\n";;
                                                         $tj[$n][$m][2]->{"type"}="v";
                                $tj[$n][$m][2]->{"value"}=$lift[2];
                                        $var_list->{$lift[2]}++;
                                        push(@{$path_list->{$lift[2]}},"$m 2");

                }
                elsif(length($lift[2])>1)
                {
                        print "$lift[2 ] 2常量\n";
                                 $tj[$n][$m][2]->{"type"}="c";
                                $tj[$n][$m][2]->{"value"}=$lift[2];
                }


                        $tj[$n][$m][1]->{"type"}="c";
                        $tj[$n][$m][1]->{"eq"}=$lift[1];
                        $hash->{$lift[1]}->{$n}=1;


                $m++;
        }
                        my $kvn1=0;
                        my $kvn2=0;
                while(my ($k,$v)=each(%{$var_list}))
                {
                                 if($v>1)
                        {
                                for(0 .. ($v-1))
                                {
                                        my $np=$_;
                                        push (@{$samelist[$n][$kvn1]},$path_list->{$k}[$np]);
                                        print "same 发现重复变量 $path_list->{$k}[$np] ----$n--- $k\n";

                                }
                                $kvn1++;
                        }
                        elsif($v==1)
                        {

                                 push (@{$uniqlist[$n][$kvn2]},$path_list->{$k}[$np]);
                                        print "uniq 唯一变量 $path_list->{$k}[$np] ----$n--- $k\n";
                                $kvn2++;
                        }




                }
$resr[$n]=$liftright[1];
$resl[$n]=$liftright[0];
        $n++;

}
open(FD,"$ARGV[1]");
#rule file
my $n=0;
#my $tj;
while(<FD>)

{
        my $line=$_;
chomp($line);
  @abc=split(" ",$line);
if(exists($hash->{$abc[1]}))
{
print "存在 $abc[1]\n";
#75926462@qq.com
        while(my ($k6,$v6)=each($hash->{$abc[1]}))
        {
        addmorexs($abc[0],$abc[1],$abc[2],$k6);
##
## %tj
## start
## $xiansuoji
#               $tatoal1=tl(\@abc,$k);
        #       if($$tatoal1 < )
        #{}
#my $tatoal2=sa("河马 喜欢 大象 小象 可能是 大象 小象 属于 幼崽 小象 可能是 大象",1);
#my $tatoal2=sa("河马 喜欢 大象 小象 可能是 大象 小象 属于 幼崽 幼崽 可能是 小动物",1);
#print "sa res=$tatoal2\n";
##my $tatoal3=un("河马 喜欢 大象 小象 可能是 大象 小象 属于 幼崽 幼崽 可能是 小动物",1);
#print "un res=$tatoal3\n";
        }
}
else
{

next;
}
}

sub addmorexs
{

        my $inp1=$_[0];
        my $inp2=$_[1];
        my $inp3=$_[2];
        my $inp4=$_[3];
        print "inp $inp1 $inp2 $inp3 $inp4||||||||\n";

        my $n_inp;
        $n_inp=scalar(@{$tj[$inp4]});
        print "$n_inp\n";
        for(0 .. scalar(@{$tj[$inp4]})-1)
        {
        my ($f,$m,$l)=0;
                my $now=$_;
        if($tj[$inp4][$now][0]->{"type"} eq "c")
        {
                print "前常量\n";
                if($tj[$inp4][$now][0]->{"value"} eq "$inp1"){
                                print "匹配前常量 $inp1\n";
                                $f=1;
                        }
                        else{$f=0;}

        }
        else{
                print "前位是变量\n";
                                $f=1;

        }


        if($tj[$inp4][$now][1]->{"eq"} eq "$inp2")
        {
                print "谓词匹配\n";
                        $m=1;

        }
        else{
                print "谓词不匹配 $inp2   ". $tj[$inp4][$now][1]->{"eq"} ."\n";
                        $m=0;

        }


       if($tj[$inp4][$now][2]->{"type"} eq "c")
        {
                print "后位是常量\n";
                if($tj[$inp4][$now][2]->{"value"} eq "$inp3"){
                                print "匹配后常量 $inp3\n";
                        $l=1;
                        }
                else
                {$l=0;}

        }
        else{
                print "后位是变量\n";
                        $l=1;


        }

        if(($f==1)&& ($m ==1)&& ($l ==1))
        {
                print "fit line $inp4 $now|$inp1 $inp2 $inp3 \n";
                my @mkey;
                my @mvvv;
                for(0 .. scalar(@{$tj[$inp4]})-1)
                {
                 my $nnt=$_;
                my $con=0;
                        if($nnt==$now)
                        {
                                $con=1;
                                $vvv=" $inp1 $inp2 $inp3 ";
                        }
                        else
                        {$con=0;$vvv=" _ _ _ "}
                        #$mkey=$mkey."$con";
                        push(@mkey,$con);
                                                 push(@mvvv,$vvv);
                }
                        my $mmkey=join("",@mkey);
                        my $mmvvv=join("",@mvvv);
                print "mkey --".$mmkey." $mmvvv\n";
#mkey --0001  _ _ _  _ _ _  _ _ _  幼崽 可能是 小动物
#             _ _ _  _ _ _  _ _ _  幼崽 可能是 动物

#mkey --0010  _ _ _  _ _ _   幼崽 可能是 小动物 _ _ _


                push (@{$xiansuoji->{$inp4}->{$mmkey}},"$mmvvv");
                my $xiansuoji2;

                while(($k,$v)=each($xiansuoji->{$inp4}))
                {
                        my @klist=split("",$k);
                        print "klist $now- @klist-$klist[$now]\n";
                        if($klist[$now]==0)
#非零不新生
                        {
                                foreach my $myarr (@{$xiansuoji->{$inp4}->{$k}})
                                {
                                my $newk;
                                my $newv;
                                        my @nv,@nk=();
                                print "merge myarr f $now to $k $myarr\n";
                                        for(0 .. scalar(@klist)-1)
                                        {my $ttp=$_;if($ttp==$now) {push(@nk,1);}
                                        else{push(@nk,$klist[$ttp])}}
                                        $newk=join("",@nk);
                                        my @ttpp=split (" ",$myarr);
                                        my @ttpp2=split (" ",$mmvvv);
                                                for(0 .. scalar(@ttpp)-1)
                                                {       my $tp4=$_;
                                                        if(($tp4 >= $now*3)&&($tp4 < ($now+1)*3))
                                                        {
                                                                push(@nv," ".$ttpp2[$tp4]);
                                                   }
                                                        else{push(@nv," ".$ttpp[$tp4]);}
                                                }
                                        $newv=join("",@nv);
                                        print " new $newk|||| $newv\n";
                                         if($newk=~/0/)
                                        {}else{$totalok++;}
print "totalok $totalok \n";

                                        push (@{$xiansuoji2->{$inp4}->{$newk}},$newv);

                                }


                        }
#                       gentnew
                }
                        my $notz=0;
                while(($k1,$v1)=each(%{$xiansuoji2->{$inp4}}))
                        {
                                $notz++;
                                                foreach my $jjj (@{$v1})
                                                {
                                        push (@{$xiansuoji->{$inp4}->{$k1}},$jjj);
                                        print "新增结果 $k1 $jjj\n";
                                        if($k1=~/0/)
                                        {}else{
                                                        my $sar=sa($jjj,$inp4);
                                                        my $unr=un($jjj,$inp4);
                                                        if(($sar eq "ok")&&($unr eq "ok"))
                                                        {print "结果成立 |$inp4 $jjj\n";

                                                                print "结论 ".$resl[$inp4],"\n";
                                                                print "结论 ".$resr[$inp4],"\n";
                                                                        my @showra=split(" ",$resr[$inp4]);
                                                                        my @ra=split(" ",$resl[$inp4]);
                                                                        my @ora=split(" ",$jjj);
                                                                        my $reshash;
                                                                        my $offset=0;
                                                                        
                                                                                                                                                for (0 .. scalar(@ra)-1)
                                                                        {
                                                                                my $rt=$_;
                                                                                if($ra[$rt] eq "&&"){$offset++;next;}
                                                                                $reshash->{$ra[$rt]}=$ora[$rt-$offset];
                                                                                print "映-射 $ra[$rt] => $reshash->{$ra[$rt]} \n";
                                                                        }
                                                                #       print "最终结论 ===->";
                                                                        for (0 .. scalar(@showra)-1)
                                                                        {
                                                                                my $rt=$_;

                                                                                if(exists($reshash->{$showra[$rt]}))
                                                                                {
                                                                                        print FDout " $reshash->{$showra[$rt]} ";
                                                                                }
                                                                                else{print FDout " $showra[$rt] "}
                                                                        }
                                                                                        print FDout "\n";

                                                                }
                                                        else
                                                        {
                                                                                        print "=================no=====\n ";
                                                                print "结果没成立 sa=$sar|un=$unr res=| $inp4 $jjj\n";
                                                        }
                                                }
                                                }
                                }
                        if($notz==0)
                        {
                                        while(($k1,$v1)=each(%{$xiansuoji->{$inp4}}))
                                        {
                                         foreach my $jjj (@{$v1})
                                                {
                                                  my $sar=sa($jjj,$inp4);
                                                        my $unr=un($jjj,$inp4);
                                                        if(($sar eq "ok")&&($unr eq "ok"))
                                                        {print "结果成立 |$inp4 $jjj\n";

                                                                print "结论 ".$resl[$inp4],"\n";
                                                                print "结论 ".$resr[$inp4],"\n";
                                                                        my @showra=split(" ",$resr[$inp4]);
                                                                        my @ra=split(" ",$resl[$inp4]);
                                                                        my @ora=split(" ",$jjj);
                                                                        my $reshash;
                                                                        my $offset=0;
                                                                        for (0 .. scalar(@ra)-1)
                                                                        {
                                                                                my $rt=$_;
                                                                                if($ra[$rt] eq "&&"){$offset++;next;}
                                                                                $reshash->{$ra[$rt]}=$ora[$rt-$offset];
                                                                                print "映射 $ra[$rt] => $reshash->{$ra[$rt]} \n";
                                                                        }
#                                                                        print "最终结论 ->";
                                                                        for (0 .. scalar(@showra)-1)
                                                                        {
                                                                                my $rt=$_;

                                                                                if(exists($reshash->{$showra[$rt]}))
                                                                                {
                                                                                        print FDout " $reshash->{$showra[$rt]} ";
                                                                                }
                                                                                else{print FDout " $showra[$rt] "}
                                                                        }
                                                                                        print FDout  "\n";

                                                                }

                                                        else
                                                        {
                                                                print "结果没成立 单条件 sa=$sar|un=$unr res=| $inp4 $jjj\n";
                                                        }
                                                        }
                                        }
                        }



                }
        }
#       print "tj--".$tj[$n][$inp4][0]->{"value"}."\n";
#       print "tj--".$tj[$n][$inp4][2]->{"type"}."\n";
#       print "tj--".$tj[$n][$inp4][2]->{"value"}."\n";
#       $xiansuoji
}



sub tl
{
        my $nn=$_[1];
print "nn  $_[0][0] $_[0][1] $_[0][2] --- $_[1]\n";


}



sub sa
{
        my $pas=$_[0];
        my $n=$_[1];
#河马 喜欢 大象 小象 可能是 大象 小象 属于 幼崽 小象 可能是 大象
my @apas=split(" ",$pas );
print "start sa  $n @apas\n";
# push (@{$samelist[$n]->{$k}},$path_list->{$k}[$np]);
                my $ctmp;
my $res="ok";
## @samelist
if(exists($samelist[$n]))
{
                                               
                                               print "发现数组 sa\n";

}
else
{
print "严重 没发现sa\n";
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
print "相同变量中 第$n行 的一个 在位置 \n";
                        print "位置 $zj $lr \n";
                        if($rn==0)
                        {
                        $ctmp=$apas[$zj*3+$lr];
                                $rn=1;
                                next;
                        }
                        elsif($ctmp eq $apas[$zj*3+$lr])
                        {
                        #       $resn++;
                        }
                        else{
                                $res="bad";
                                print "wrong--- ctmp=$ctmp apas=".$apas[$zj*3+$lr] ."---".($zj*3+$lr)."-@apas--------------------\n";

                                return $ctmp;
                                #last;
                        }
                                print "org $ctmp ".$apas[$zj*3+$lr]."\n";


                }

}


        if($res eq "ok")
        {$res="ok";print "find same ok\n";}
return $res;


}

sub un
{
my $pas=$_[0];
        my $n=$_[1];
print "start un $_[0] $_[1]\n";
my @apas=split(" ",$pas);
my $res;
my $rn=0;
## @uniqlist
if(exists($uniqlist[$n]))
{
print "发现数组 un\n";

}
else
{
print "没发现un\n";
}

for (0 .. scalar(@{$uniqlist[$n]})-1)
{

                my $iii=$_;
                my $wz=$uniqlist[$n][$iii][0];
                                                                 
                                                                 
                                                                 
                                                                 
                                                                         print "唯一集合中 第$n行 变量是$k 位置是 $wz\n";
                 $wz=~/(.*?) (.*)/;
                         my $zj=$1;
                        my $lr=$2;
                my $ctmp;
                        $ctmp=$apas[$zj*3+$lr];
#               $ctmp=$apas[$wz];
        print "un--$wz--$ctmp --------$zj-$lr--v \n";
#   push (@{$uniqlist[$n]->{$k}},$path_list->{$k}[$np]);


                $rn=0;
                        for(0 .. scalar(@apas)-1)
                        {
                                my $ggn=$_;
                                print "un ctmp $ctmp $apas[$ggn]\n";
                        if($ctmp eq $apas[$ggn])
                        {
                                $rn++;
                        print "uniq 发现1个 $ctmp\n";

                        }
                        if($rn>=2){
                                $res=$ctmp;
                                print "un wrong--- ctmp=$ctmp -@apas--------------------\n";
                                return $ctmp;
                        }
#                                print "org $ctmp ".$apas[$zj*3+$lr]."\n";
                        }



}
#$res=$rn;
if($rn==1){$res="ok";};
print "unres $res\n";
return $res;



}



                                                                           
