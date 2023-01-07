/* Iterator.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public interface Caramelo.Iterator<G> : Object {
    public abstract bool has_next ();
    public abstract bool next ();
    public abstract new G @get ();
}
