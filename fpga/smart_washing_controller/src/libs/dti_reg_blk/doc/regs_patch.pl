#!/usr/bin/perl
use strict;

my  @lst = (
  [ "vrefcar_reg_ptsr0_ip"      , 1 ],
  [ "vrefcas_reg_ptsr0_ip"      , 6 ],
  [ "csc0_reg_ptsr0_ip"         , 6 ],
  [ "csc1_reg_ptsr0_ip"         , 6 ],
  [ "cac0b0_reg_ptsr0_ip"       , 6 ],
  [ "cac0b1_reg_ptsr0_ip"       , 6 ],
  [ "cac0b2_reg_ptsr1_ip"       , 6 ],
  [ "cac0b3_reg_ptsr1_ip"       , 6 ],
  [ "cac0b4_reg_ptsr1_ip"       , 6 ],
  [ "cac0b5_reg_ptsr1_ip"       , 6 ],
  [ "cac1b0_reg_ptsr1_ip"       , 6 ],
  [ "cac1b1_reg_ptsr2_ip"       , 6 ],
  [ "cac1b2_reg_ptsr2_ip"       , 6 ],
  [ "cac1b3_reg_ptsr2_ip"       , 6 ],
  [ "cac1b4_reg_ptsr2_ip"       , 6 ],
  [ "cac1b5_reg_ptsr2_ip"       , 6 ],
  [ "gts0_reg_ptsr3_ip"         , 6 ],
  [ "gts1_reg_ptsr3_ip"         , 6 ],
  [ "gts2_reg_ptsr3_ip"         , 6 ],
  [ "gts3_reg_ptsr3_ip"         , 6 ],
  [ "vrefdqwrr_reg_ptsr3_ip"    , 1 ],
  [ "vrefdqwrs_reg_ptsr3_ip"    , 6 ],
  [ "wrlvls0_reg_ptsr4_ip"      , 8 ],
  [ "wrlvls1_reg_ptsr4_ip"      , 8 ],
  [ "wrlvls2_reg_ptsr4_ip"      , 8 ],
  [ "wrlvls3_reg_ptsr4_ip"      , 8 ],
  [ "psck_reg_ptsr5_ip"         , 4 ],
  [ "usck_reg_ptsr5_ip"         , 4 ],
  [ "dqsdqs0_reg_ptsr6_ip"      , 8 ],
  [ "dqsdqs1_reg_ptsr6_ip"      , 8 ],
  [ "dqsdqs2_reg_ptsr6_ip"      , 8 ],
  [ "dqsdqs3_reg_ptsr6_ip"      , 8 ],
  [ "rdlvldqs0b0_reg_ptsr7_ip"  , 8 ],
  [ "rdlvldqs0b1_reg_ptsr7_ip"  , 8 ],
  [ "rdlvldqs0b2_reg_ptsr7_ip"  , 8 ],
  [ "rdlvldqs0b3_reg_ptsr7_ip"  , 8 ],
  [ "rdlvldqs0b4_reg_ptsr8_ip"  , 8 ],
  [ "rdlvldqs0b5_reg_ptsr8_ip"  , 8 ],
  [ "rdlvldqs0b6_reg_ptsr8_ip"  , 8 ],
  [ "rdlvldqs0b7_reg_ptsr8_ip"  , 8 ],
  [ "rdlvldqs1b0_reg_ptsr9_ip"  , 8 ],
  [ "rdlvldqs1b1_reg_ptsr9_ip"  , 8 ],
  [ "rdlvldqs1b2_reg_ptsr9_ip"  , 8 ],
  [ "rdlvldqs1b3_reg_ptsr9_ip"  , 8 ],
  [ "rdlvldqs1b4_reg_ptsr10_ip" , 8 ],
  [ "rdlvldqs1b5_reg_ptsr10_ip" , 8 ],
  [ "rdlvldqs1b6_reg_ptsr10_ip" , 8 ],
  [ "rdlvldqs1b7_reg_ptsr10_ip" , 8 ],
  [ "rdlvldqs2b0_reg_ptsr11_ip" , 8 ],
  [ "rdlvldqs2b1_reg_ptsr11_ip" , 8 ],
  [ "rdlvldqs2b2_reg_ptsr11_ip" , 8 ],
  [ "rdlvldqs2b3_reg_ptsr11_ip" , 8 ],
  [ "rdlvldqs2b4_reg_ptsr12_ip" , 8 ],
  [ "rdlvldqs2b5_reg_ptsr12_ip" , 8 ],
  [ "rdlvldqs2b6_reg_ptsr12_ip" , 8 ],
  [ "rdlvldqs2b7_reg_ptsr12_ip" , 8 ],
  [ "rdlvldqs3b0_reg_ptsr13_ip" , 8 ],
  [ "rdlvldqs3b1_reg_ptsr13_ip" , 8 ],
  [ "rdlvldqs3b2_reg_ptsr13_ip" , 8 ],
  [ "rdlvldqs3b3_reg_ptsr13_ip" , 8 ],
  [ "rdlvldqs3b4_reg_ptsr14_ip" , 8 ],
  [ "rdlvldqs3b5_reg_ptsr14_ip" , 8 ],
  [ "rdlvldqs3b6_reg_ptsr14_ip" , 8 ],
  [ "rdlvldqs3b7_reg_ptsr14_ip" , 8 ],
  [ "rdlvldms0_reg_ptsr15_ip"   , 8 ],
  [ "rdlvldms1_reg_ptsr15_ip"   , 8 ],
  [ "rdlvldms2_reg_ptsr15_ip"   , 8 ],
  [ "rdlvldms3_reg_ptsr15_ip"   , 8 ],
  [ "vrefdqrds0_reg_ptsr16_ip"  , 6 ],
  [ "vrefdqrds1_reg_ptsr16_ip"  , 6 ],
  [ "vrefdqrds2_reg_ptsr16_ip"  , 6 ],
  [ "vrefdqrds3_reg_ptsr16_ip"  , 6 ]
);

#   Get field width spaces
foreach my $item (@lst) {
  printf "Patching $item->[0] ... ";
  my  $str = `cat ../hdl/rb_regs.sv | grep $item->[0] | grep 'input\\\|output'`;
  $str =~ s/\n//;
  $str =~ s/\r//;
  $item->[1]--;
  if ($item->[1] > 0) {
    $str =~ s/(.*)(\S)\s+[\[\]\:\d]*\s+$item->[0](.*)/$1$2 [$item->[1]:0] $item->[0]$3/;
  }
  else {
    $str =~ s/(.*)(\S)\s+[\[\]\:\d]*\s+$item->[0](.*)/$1$2       $item->[0]$3/;
  }
  #printf "sed -i 's/.*input .*$item->[0].*/$str/' ../hdl/dti_phy_regs.v\n";
  #printf "sed -i 's/.*output .*$item->[0].*/$str' ../hdl/dti_phy_regs.v";
  #printf "sed -i 's/.*inout .*$item->[0].*/$str' ../hdl/dti_phy_regs.v";
  my  $result = `sed -i 's/.*input .*$item->[0].*/$str/' ../hdl/rb_regs.sv`;
  printf "Done\n";
}
