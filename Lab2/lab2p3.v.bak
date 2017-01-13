module lab2p3(HEXO, SW);

    input [3:0] SW;

    output [6:0] HEXO;




    kkk u0(

        .c3(SW[3]),

        .c2(SW[2]),

        .c1(SW[1]),

        .c0(SW[0]),

        .h0(HEXO[0]),

        .h1(HEXO[1]),

        .h2(HEXO[2]),

        .h3(HEXO[3]),

        .h4(HEXO[4]),

        .h5(HEXO[5]),

        .h6(HEXO[6])

        );

endmodule




module kkk(c3,c2,c1,c0,h0,h1,h2,h3,h4,h5,h6);

    input c3,c2,c1,c0;

    output h0,h1,h2,h3,h4,h5,h6;




    assign h0=~((c3|c2|c1|~c0)&(c3|~c2|c1|c0)&(~c3|c2|~c1|~c0)&(~c3|~c2|~c1|c0));

    assign h1=~((c3|~c2|~c1|c0)&(c3|~c2|c1|~c0)&(~c3|c2|~c1|~c0)&(~c3|~c2|c1|c0)&(~c3|~c2|~c1|c0)&(~c3|~c2|~c1|~c0));

    assign h2=~((c3|c2|~c1|c0)&(~c3|~c2|c1|c0)&(~c3|~c2|~c1|c0)&(~c3|~c2|~c1|~c0));

    assign h3=~((c3|c2|c1|~c0)&(c3|~c2|c1|c0)&(c3|~c2|~c1|~c0)&(~c3|c2|c1|~c0)&(~c3|c2|~c1|c0)&(~c3|~c2|~c1|~c0));

    assign h4=~((c3|c2|c1|~c0)&(c3|c2|~c1|~c0)&(c3|~c2|c1|c0)&(c3|~c2|c1|~c0)&(c3|~c2|~c1|~c0)&(~c3|c2|c1|~c0));

    assign h5=~((c3|c2|c1|~c0)&(c3|c2|~c1|c0)&(c3|c2|~c1|~c0)&(c3|~c2|~c1|~c0)&(~c3|~c2|c1|~c0));

    assign h6=~((c3|c2|c1|c0)&(c3|c2|c1|~c0)&(c3|~c2|~c1|~c0)&(~c3|~c2|c1|c0));




endmodule