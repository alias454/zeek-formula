{% from "zeek/map.jinja" import host_lookup as config with context -%}
##! Managed by Salt Do not edit
##! Originally I found this solution in Security Onion and liked the way it worked.
##! Original source located https://github.com/Security-Onion-Solutions/securityonion-zeek-scripts

module BPFconf;

@load ./interface
@load base/frameworks/input

export
{
    global sensorname = "";

    type Idx: record {
        interface: string;    
    };

    type Val: record {
        sensorname: string;
    };

    global sensornames: table[string] of Val = table();
}

event zeek_init() &priority=5
{
    Input::add_table([
        $source="{{ config.zeek.CfgDir }}/sensortab.zeek",
        $name="sensornames",
        $idx=Idx,
        $val=Val,
        $destination=sensornames]);

    Input::remove("sensornames");
}
