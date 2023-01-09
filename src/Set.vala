/* Set.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

[GenericAccessors]
public interface Caramelo.Set<G> : Caramelo.Collection<G> {
    public abstract bool equals (Set @set);
    public abstract bool remove_all (Collection<G> collection);
}
