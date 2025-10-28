
import '../models/product.dart';

const mockProducts = <Product>[
  Product(
    id: 'lp-001',
    title: 'Kind of Blue',
    artist: 'Miles Davis',
    price: 22000,
    imageUrl: 'https://picsum.photos/seed/blue/600/400',
    stock: 10,
    tags: ['jazz', 'classic'],
  ),
  Product(
    id: 'lp-002',
    title: 'Abbey Road',
    artist: 'The Beatles',
    price: 25000,
    imageUrl: 'https://picsum.photos/seed/abbey/600/400',
    stock: 8,
    tags: ['rock', 'classic'],
  ),
  Product(
    id: 'lp-003',
    title: 'Blackstar',
    artist: 'David Bowie',
    price: 24000,
    imageUrl: 'https://picsum.photos/seed/blackstar/600/400',
    stock: 5,
    tags: ['rock'],
  ),
  Product(
    id: 'lp-004',
    title: 'Discovery',
    artist: 'Daft Punk',
    price: 26000,
    imageUrl: 'https://picsum.photos/seed/discovery/600/400',
    stock: 12,
    tags: ['electronic'],
  ),
  Product(
    id: 'lp-005',
    title: 'Blue Train',
    artist: 'John Coltrane',
    price: 23000,
    imageUrl: 'https://picsum.photos/seed/train/600/400',
    stock: 7,
    tags: ['jazz'],
  ),
];
