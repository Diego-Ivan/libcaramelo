/* Iterable.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.Iterable<G> : Object {
    public abstract Iterator<G> iterator ();
}
