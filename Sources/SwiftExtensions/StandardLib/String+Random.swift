//
//  File.swift
//  
//
//  Created by Jo on 2024/2/2.
//

import Foundation

public extension String {
    static func random(length: Int) -> String {
        let randomNumber: () -> UInt8 = {
            return UInt8.random(in: 32...126)
        }
        
        let randomAsciiChar: () -> Character = {
            return Character(UnicodeScalar(randomNumber()))
        }

        return String((0..<length).map { _ in randomAsciiChar() })
    }
    
    static func random(length: Range<Int>) -> String {
        return random(length: Int.random(in: length))
    }
    
    static func random(length: Range<Int>, count: Range<Int>) -> [String] {
        let randomCount = Int.random(in: count)
        var location: Int = 0
        var results: [String] = []
        
        while location < randomCount {
            results.append(random(length: length))
            location += 1
        }
        
        return results
    }
}

/**
  0 ~ 31为控制字符
  32 为空格
 
  33     041    21    00100001    !    &#033;    感叹号
  34     042    22    00100010    "    &#034;    双引号
  35     043    23    00100011    #    &#035;    井号
  36     044    24    00100100    $    &#036;    美元符
  37     045    25    00100101    %    &#037;    百分号
  38     046    26    00100110    &    &#038;    与
  39     047    27    00100111    '    &#039;    单引号
  40     050    28    00101000    (    &#040;    左括号
  41     051    29    00101001    )    &#041;    右括号
  42     052    2A    00101010    *    &#042;    星号
  43     053    2B    00101011    +    &#043;    加号
  44     054    2C    00101100    ,    &#044;    逗号
  45     055    2D    00101101    -    &#045;    连字号或减号
  46     056    2E    00101110    .    &#046;    句点或小数点
  47     057    2F    00101111    /    &#047;    斜杠
  48     060    30    00110000    0    &#048;    0
  49     061    31    00110001    1    &#049;    1
  50     062    32    00110010    2    &#050;    2
  51     063    33    00110011    3    &#051;    3
  52     064    34    00110100    4    &#052;    4
  53     065    35    00110101    5    &#053;    5
  54     066    36    00110110    6    &#054;    6
  55     067    37    00110111    7    &#055;    7
  56     070    38    00111000    8    &#056;    8
  57     071    39    00111001    9    &#057;    9
  58     072    3A    00111010    :    &#058;    冒号
  59     073    3B    00111011    ;    &#059;    分号
  60     074    3C    00111100    <    &#060;    小于
  61     075    3D    00111101    =    &#061;    等号
  62     076    3E    00111110    >    &#062;    大于
  63     077    3F    00111111    ?    &#063;    问号
  64     100    40    01000000    @    &#064;    电子邮件符号
  65     101    41    01000001    A    &#065;    大写字母 A
  66     102    42    01000010    B    &#066;    大写字母 B
  67     103    43    01000011    C    &#067;    大写字母 C
  68     104    44    01000100    D    &#068;    大写字母 D
  69     105    45    01000101    E    &#069;    大写字母 E
  70     106    46    01000110    F    &#070;    大写字母 F
  71     107    47    01000111    G    &#071;    大写字母 G
  72     110    48    01001000    H    &#072;    大写字母 H
  73     111    49    01001001    I    &#073;    大写字母 I
  74     112    4A    01001010    J    &#074;    大写字母 J
  75     113    4B    01001011    K    &#075;    大写字母 K
  76     114    4C    01001100    L    &#076;    大写字母 L
  77     115    4D    01001101    M    &#077;    大写字母 M
  78     116    4E    01001110    N    &#078;    大写字母 N
  79     117    4F    01001111    O    &#079;    大写字母 O
  80     120    50    01010000    P    &#080;    大写字母 P
  81     121    51    01010001    Q    &#081;    大写字母 Q
  82     122    52    01010010    R    &#082;    大写字母 R
  83     123    53    01010011    S    &#083;    大写字母 S
  84     124    54    01010100    T    &#084;    大写字母 T
  85     125    55    01010101    U    &#085;    大写字母 U
  86     126    56    01010110    V    &#086;    大写字母 V
  87     127    57    01010111    W    &#087    大写字母 W
  88     130    58    01011000    X    &#088;    大写字母 X
  89     131    59    01011001    Y    &#089;    大写字母 Y
  90     132    5A    01011010    Z    &#090;    大写字母 Z
  91     133    5B    01011011    [    &#091;    左中括号
  92     134    5C    01011100    \    &#092;    反斜杠
  93     135    5D    01011101    ]    &#093;    右中括号
  94     136    5E    01011110    ^    &#094;    音调符号
  95     137    5F    01011111    _    &#095;    下划线
  96     140    60    01100000    `    &#096;    重音符
  97     141    61    01100001    a    &#097;    小写字母 a
  98     142    62    01100010    b    &#098;    小写字母 b
  99     143    63    01100011    c    &#099;    小写字母 c
  100    144    64    01100100    d    &#100;    小写字母 d
  101    145    65    01100101    e    &#101;    小写字母 e
  102    146    66    01100110    f    &#102;    小写字母 f
  103    147    67    01100111    g    &#103;    小写字母 g
  104    150    68    01101000    h    &#104;    小写字母 h
  105    151    69    01101001    i    &#105;    小写字母 i
  106    152    6A    01101010    j    &#106;    小写字母 j
  107    153    6B    01101011    k    &#107;    小写字母 k
  108    154    6C    01101100    l    &#108;    小写字母 l
  109    155    6D    01101101    m    &#109;    小写字母 m
  110    156    6E    01101110    n    &#110;    小写字母 n
  111    157    6F    01101111    o    &#111;    小写字母 o
  112    160    70    01110000    p    &#112;    小写字母 p
  113    161    71    01110001    q    &#113;    小写字母 q
  114    162    72    01110010    r    &#114;    小写字母 r
  115    163    73    01110011    s    &#115;    小写字母 s
  116    164    74    01110100    t    &#116;    小写字母 t
  117    165    75    01110101    u    &#117;    小写字母 u
  118    166    76    01110110    v    &#118;    小写字母 v
  119    167    77    01110111    w    &#119;    小写字母 w
  120    170    78    01111000    x    &#120;    小写字母 x
  121    171    79    01111001    y    &#121;    小写字母 y
  122    172    7A    01111010    z    &#122;    小写字母 z
  123    173    7B    01111011    {    &#123;    左大括号
  124    174    7C    01111100    |    &#124;    垂直线
  125    175    7D    01111101    }    &#125;    右大括号
  126    176    7E    01111110    ~    &#126;    波浪号
*/
