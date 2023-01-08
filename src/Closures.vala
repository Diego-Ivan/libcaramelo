/* Closures.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

protected class Caramelo.EqualFuncClosure<G> {
    private EqualFunc<G> _equal_func;
    public EqualFunc<G>? equal_func {
        get {
            return _equal_func;
        }
        set {
            if (value == null) {
                _equal_func = get_for_type (typeof(G));
                return;
            }
            equal_func = value;
        }
    }

    private EqualFunc<G> get_for_type (Type type) {
        switch (type) {
            case Type.STRING:
                return str_equal;

            case Type.INT:
            case Type.UINT:
                return int_equal;

            case Type.DOUBLE:
            case Type.FLOAT:
                return (EqualFunc<double>) double_equal;
            default:
                return direct_equal;
        }
    }

    private bool double_equal (double a, double b) {
        return a == b;
    }
}

protected class Caramelo.HashFuncClosure<K> {
    private HashFunc<K> _hash_func;
    public HashFunc<K>? hash_func {
        get {
            return _hash_func;
        }
        set {
            if (value == null) {
                _hash_func = get_default ();
                return;
            }
            _hash_func = value;
        }
    }

    private HashFunc<K> get_default () {
        switch (typeof(K)) {
            case Type.STRING:
                return str_hash;

            case Type.INT:
            case Type.UINT:
                return int_hash;

            default:
                return direct_hash;
        }
    }
}
