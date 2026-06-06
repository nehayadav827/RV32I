class packet;
    rand bit jump;
    rand bit value; 
    rand bit jalr;
    rand bit brh;
    randc bit [2:0] func_b;
    rand bit [31:0] src_reg_1;
    rand bit [31:0] src_reg_2;
    rand bit [31:0] imm;
    rand bit [31:0] pc_in;

    constraint c_func_b { func_b < 6 ;}
    constraint c_imm { imm[0]== 0 ;}
    constraint c_pc_in { pc_in[0] == 0 ;}
    constraint c_j_b { jump + jalr + brh <= 1; }

endclass