/* BidirectionalIterator.vala
 *
 * Copyright 2023 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-3.0-or-later
 */

public interface Caramelo.BidirectionalIterator<T> : Iterator<T> {
    public abstract bool previous ();
    public abstract bool has_previous ();
}
