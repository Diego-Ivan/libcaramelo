/* TestCase.vala
 *
 * Based on Libgee's Test Case
 *
 * Copyright (C) 2009 Julien Peeters
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public abstract class Caramelo.TestCase : Object {
    public TestSuite test_suite { get; protected set; }
    private UnitTest[] tests = {};

    public delegate void TestMethod ();

    protected TestCase (string name) {
        Object (
            test_suite: new TestSuite (name)
        );
    }

    protected void add_test (string test_name, owned TestMethod test_func) {
        var unit_test = new UnitTest (test_name, (owned) test_func, this);
        test_suite.add (unit_test.to_g_test_case ());
        tests += unit_test;
    }

    protected void setup () {
    }

    protected void teardown () {
    }

    protected class UnitTest : Object {
        public string name { get; set; }
        protected TestMethod test_func;
        public TestCase test_case { get; protected set; }

        public UnitTest (string name, owned TestMethod test_func, TestCase test_case) {
            Object (
                name: name,
                test_case: test_case
            );

            this.test_func = (owned) test_func;
        }

        public GLib.TestCase to_g_test_case () {
            return new GLib.TestCase (name, setup, run, tear_down);
        }

        public void run () {
            print ("\nRunning: %s\n", name);
            test_func ();
        }

        public void setup (void* fixture) {
            test_case.setup ();
        }

        public void tear_down (void* fixture) {
            test_case.teardown ();
        }
    }
}
