/* ListTest.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public class Caramelo.ListTest : Caramelo.CollectionTest {
    public Caramelo.List<string> list { get; private set; }
    public ListTest (string name, Caramelo.List<string> list) {
        base (name, list);
        this.list = list;

        add_test ("[List]: Get", get_test);
        add_test ("[List]: Set", set_test);
        add_test ("[List]: Index Of", index_of_test);
        add_test("[List]: Iterator", iterator_test);
        add_test ("[List]: Foreach", foreach_test);
        add_test ("[List]: Insert", insert_test);
        add_test ("[List]: Slice", slice_test);
        add_test ("[List]: First and Last", first_last_test);
    }

    public void get_test () {
        list.clear ();
        string[] str_array = { "Luna", "Sol", "Tierra", "Marte", "Júpiter" };

        foreach (string str in str_array) {
            list.add (str);
        }

        for (int i = 0; i < str_array.length; i++) {
            assert_true (str_array[i] == list[i]);
        }
    }

    public void set_test () {
        list.clear ();
        string[] str_array = {
            "Car", "Bike", "Train", "Subway", "Taxi"
        };
        foreach (string str in str_array) {
            list.add (str);
        }

        list[0] = "Something";
        assert_true (list[0] == "Something");
        assert_false (str_array[0] != list[0]);

        for (int i = 1; i < str_array.length; i++) {
            assert_true (list[i] == str_array[i]);
        }

        list[2] = "Another Thing";
        assert_true (list[2] == "Another Thing");
        assert_false (list[2] == str_array[2]);

        for (int i = 3; i < str_array.length; i++) {
            assert_true (list[i] == str_array[i]);
        }
    }

    public void index_of_test () {
        list.clear ();
        list.add ("Hello");
        list.add ("Light");
        list.add ("Mice");
        list.add ("Keyboard");

        assert_true (list.index_of ("Hello") == 0);
        assert_true (list.index_of ("Mice") == 2);
        assert_true (list.index_of ("Keyboard") == 3);
        assert_true (list.index_of ("Horn") == -1);
    }

    public void iterator_test () {
        list.clear ();
        string[] str_array = { "Louis", "Mike", "Jenny", "Albert" };

        foreach (string str in str_array) {
            list.add (str);
        }

        Caramelo.Iterator<string> iterator = list.iterator ();
        while (iterator.next ()) {
            print (iterator.get () + "\n");
        }
    }

    public void foreach_test () {
        list.clear ();
        string[] str_array = { "Louis", "Mike", "Jenny", "Albert" };

        foreach (string str in str_array) {
            list.add (str);
        }

        int i = 0;
        foreach (string str in list) {
            print ("%s : %s\n", str_array[i], str);
            i++;
        }
    }

    public void insert_test () {
        list.clear ();

        list.add ("Hello");
        list.add ("Light");
        list.add ("Mice");
        list.add ("Keyboard");

        list.insert (0, "Pen");
        assert_true (list[0] == "Pen");
        assert_true (list[1] == "Hello");

        list.insert (2, "Air");
        assert_true (list[2] == "Air");
        assert_true (list[2] == "Light");

        list.insert (list.size - 1, "Song");
        assert_true (list[list.size - 1] == "Song");
        assert_true (list[list.size - 2] == "Keyboard");
    }

    public void slice_test () {
        list.clear ();

        string str_array[] = { "Bottle", "Plastic", "Bag", "Yogurt", "USB" };
        string[] sliced_array = str_array [1:3];

        list.add_from_array (str_array);
        var sliced_list = list[1:3];

        assert_true (sliced_array.length == sliced_list.size);

        for (int i = 0; i < sliced_array.length; i++) {
            assert_true (sliced_array[i] == sliced_list[i]);
        }
    }

    public void first_last_test () {
        list.clear ();

        string str_array[] = { "Bottle", "Plastic", "Bag", "Yogurt", "USB" };
        list.add_from_array (str_array);

        assert_true (list.first () == str_array[0]);
        assert_true (list.last () == str_array[str_array.length - 1]);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    var single_test = new Caramelo.ListTest ("SingleLinkedList", new Caramelo.SingleLinkedList<string> ());

    TestSuite.get_root ().add_suite (single_test.test_suite);

    return Test.run ();
}
