import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_provider/data/api_config.dart';
import 'package:movie_provider/domain/entities/movie.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieCard extends StatelessWidget {
  final Movie? movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: movie?.saved ?? false
            ? const Color.fromARGB(255, 112, 118, 230)
            : const Color.fromARGB(255, 212, 208, 208),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: movie?.posterPath?.isNotEmpty ?? false
                  ? CachedNetworkImage(
                      imageUrl: ApiConfig.imageUrl(
                        movie?.posterPath ?? '',
                      ),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : const SizedBox(),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie?.title ?? '-',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15),
                  maxLines: 1,
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text((movie?.releaseDate ?? '').split('-')[0]),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      ((movie?.voteAverage ?? 0) / 2).toStringAsFixed(1),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  movie?.overview ?? '-',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
