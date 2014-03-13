using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EdmSetManagement.Core.CuesheetTools.ForumExtraction
{
	public static class ProjectionComparer
	{
		public static IEnumerable<TSource> DistinctBy<TSource, TValue>(
			this IEnumerable<TSource> source,
			Func<TSource, TValue> selector)
		{
			var comparer = ProjectionComparer<TSource>.CompareBy<TValue>(
				selector, EqualityComparer<TValue>.Default);
			return new HashSet<TSource>(source, comparer);
		}
	}
	
	public static class ProjectionComparer<TSource>
	{
		public static IEqualityComparer<TSource> CompareBy<TValue>(
			Func<TSource, TValue> selector)
		{
			return CompareBy<TValue>(selector, EqualityComparer<TValue>.Default);
		}
		public static IEqualityComparer<TSource> CompareBy<TValue>(
			Func<TSource, TValue> selector,
			IEqualityComparer<TValue> comparer)
		{
			return new ComparerImpl<TValue>(selector, comparer);
		}
		sealed class ComparerImpl<TValue> : IEqualityComparer<TSource>
		{
			private readonly Func<TSource, TValue> selector;
			private readonly IEqualityComparer<TValue> comparer;
			public ComparerImpl(
				Func<TSource, TValue> selector,
				IEqualityComparer<TValue> comparer)
			{
				if (selector == null) throw new ArgumentNullException("selector");
				if (comparer == null) throw new ArgumentNullException("comparer");
				this.selector = selector;
				this.comparer = comparer;
			}

			bool IEqualityComparer<TSource>.Equals(TSource x, TSource y)
			{
				if (x == null && y == null) return true;
				if (x == null || y == null) return false;
				return comparer.Equals(selector(x), selector(y));
			}

			int IEqualityComparer<TSource>.GetHashCode(TSource obj)
			{
				return obj == null ? 0 : comparer.GetHashCode(selector(obj));
			}
		}
	}
}
