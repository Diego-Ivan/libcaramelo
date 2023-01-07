/* Collection.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.Collection<G> : Iterable<G> {
    public abstract int size { get; protected set; }
    public abstract bool empty { get; }

    public abstract void add (G data);
    public abstract bool contains (G data);
    public abstract void clear ();
    public abstract bool remove (G data);
    public abstract bool remote_at (int index);
    public abstract G[] to_array ();

    public virtual void add_from_array (G[] data_array) {
        foreach (G data in data_array) {
            add (data);
        }
    }
}
