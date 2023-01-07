/* List.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.List<G> : Object, Collection<G> {
    public abstract new G @get (int index);
    public abstract new void @set (int index, G data);
    public abstract int index_of (G data);
    public abstract void insert (int index, G data);
    public abstract List<G> slice (long start, long end);
    public abstract G first ();
    public abstract G last ();
}
