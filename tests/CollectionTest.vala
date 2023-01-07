/* CollectionTest.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public abstract class Caramelo.CollectionTest : Caramelo.TestCase {
    public Caramelo.Collection<string> collection { get; protected set; }

    protected CollectionTest (string name, Caramelo.Collection<string> collection) {
        base (name);
        this.collection = collection;

        add_test ("[Collection]: Add and Remove", add_and_remove);
        add_test ("[Collection]: Clear", clear);
        add_test ("[Collection]: Remove at", remove_at_test);
        add_test ("[Collection]: To Array", to_array_test);
        add_test ("[Collection] From Array", from_array_test);
    }

    public void add_and_remove () {
        string[] dummy_array = { "gato", "cat", "perro", "dog" };

        collection.add (dummy_array[0]);
        collection.add (dummy_array[2]);

        assert_true (dummy_array[0] in collection);
        assert_true (dummy_array[2] in collection);
        assert_true (collection.size == 2);
        assert_false (collection.empty);

        collection.remove (dummy_array[0]);
        collection.remove (dummy_array[2]);

        assert_true (collection.size == 0);
        assert_false (dummy_array[0] in collection);
        assert_false (dummy_array[2] in collection);
    }

    public void clear () {
        collection.add ("Cookies");
        collection.add ("Ice Cream");
        collection.add ("Apples");
        collection.add ("Bees");

        collection.clear ();
        assert_true (collection.empty);
    }

    public void remove_at_test () {
        collection.clear ();

        collection.add ("Flower Boy");
        collection.add ("Rennaissance");
        collection.add ("4:44");
        collection.add ("KicK III");
        collection.add ("Starboy");
        collection.add ("Delusion");

        collection.remove_at (0);
        assert_false ("Flower Boy" in collection);

        collection.remove_at (1);
        assert_false ("KicK III" in collection);
    }

    public void to_array_test () {
        collection.clear ();

        string[] array_test = {
            "Sweet", "Candy", "Gummy", "Bear", "Donuts"
        };

        foreach (string str in array_test) {
            collection.add (str);
        }

        string[] result_array = collection.to_array ();
        print ("%i : %i : %i\n", array_test.length, collection.size, result_array.length);

        for (int i = 0; i < result_array.length; i++) {
            print ("%s : %s\n", array_test[i], result_array[i]);
        }
    }

    public void from_array_test () {
        collection.clear ();
        string[] array_test = { "John", "Peter", "Martha", "Luisa" };
        collection.add_from_array (array_test);


        foreach (string str in array_test) {
            assert_true (str in collection);
        }
    }
}
