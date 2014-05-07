var lang = {
    eval: function(parsed_array) {
        var name = parsed_array[0];
        return lang.table[name](parsed_array);
    },

    lookup: function(id) {
        return lang.table[id];
    },

    get_arg: function(arg_num, arg_list) {
        if (typeof(arg_list[arg_num]) === "string") {
            return lang.lookup(arg_list[arg_num]);
        } else if (arg_list[arg_num] instanceof Array) {
            return lang.eval(arg_list[arg_num]);
        } else {
            return arg_list[arg_num];
        }
    },

    table: {
        "+": function(arg_list) {
            sum = lang.get_arg(1, arg_list);
            for (i = 2; i < arg_list.length; i++) {
                sum += lang.get_arg(i, arg_list);
            }
            return sum;
        },
        "-": function(arg_list) {
            sub = lang.get_arg(1, arg_list);
            for (i = 2; i < arg_list.length; i++) {
                sub -= lang.get_arg(i, arg_list);
            }
            return sub;
        },
        "*": function(arg_list) {
            mul = lang.get_arg(1, arg_list);
            for (i = 2; i < arg_list.length; i++) {
                mul *= lang.get_arg(i, arg_list);
            }
            return mul;
        },
        "/": function(arg_list) {
            div = lang.get_arg(1, arg_list);
            for (i = 2; i < arg_list.length; i++) {
                div /= lang.get_arg(i, arg_list);
            }
            return div;
        },
        "%": function(arg_list) {
            mod = lang.get_arg(1, arg_list);
            for (i = 2; i < arg_list.length; i++) {
                mod = mod % lang.get_arg(i, arg_list);
            }
            return mod;
        },
        "<": function(arg_list) {
            return lang.get_arg(1, arg_list) < lang.get_arg(2, arg_list);
        },
        ">": function(arg_list) {
            return lang.get_arg(1, arg_list) > lang.get_arg(2, arg_list);
        },
        "=": function(arg_list) {
            return lang.get_arg(1, arg_list) == lang.get_arg(2, arg_list);
        },
        "if": function(arg_list) {
            if (lang.get_arg(1, arg_list)) {
                return lang.get_arg(2, arg_list);
            } else {
                return lang.get_arg(3, arg_list);
            }
        },
        "#": function(arg_list) {
            var value = lang.get_arg(1, arg_list);
            lang.table[arg_list[2]] = value;
            return value;
        },
        "for": function(arg_list) {
            statements = new Array();
            repeat = lang.get_arg(1, arg_list);
            for (var i = 0; i < repeat; i++) {
                statements.push(arg_list[2].slice());
                lang.eval(statements[i]);
            }
            return "for";
        },
        ".": function(arg_list) {
            for (var i = 1; i < arg_list.length; i++) {
                lang.eval(arg_list[i]);
            }
            return "block";
        },
        "v": function(arg_list) {
            return { x: arg_list[1], y: arg_list[2], z: arg_list[3] };
        },
        "js": function(arg_list) {
            eval(arg_list[1]);
            return 1;
        },
        "rotate_z": function(arg_list) {
            var rad = lang.get_arg(1, arg_list);
            actor.rotate_z(rad);
            return 1;
        },
        "rotate_y": function(arg_list) {
            var rad = lang.get_arg(1, arg_list);
            actor.rotate_y(rad);
            return 1;
        },
        "rotate_x": function(arg_list) {
            var rad = lang.get_arg(1, arg_list);
            actor.rotate_x(rad);
            return 1;
        },
        "translate": function(arg_list) {
            var vec = lang.get_arg(1, arg_list);
            actor.translate(vec.x, vec.y, vec.z);
            return 1;
        },
        "scale": function(arg_list) {
            var vec = lang.get_arg(1, arg_list);
            actor.scale(vec.x, vec.y, vec.z);
            return 1;
        },
        "reset": function(arg_list) {
            actor.reset_state();
            return 1;
        },
    }
}
