export downloads

const PACKAGE_REQUESTS_BY_DATE_PATH = Ref{String}()
"""
    package_download_counts(;[redownload])

Download package download stats and report results as a dictionary mapping package UUID to
number of downloads in the last year.

Caches downloaded file to reduce load on file hosts. Pass `redownload=true` to ignore
cached downloads.
"""
function package_requests_by_date(; redownload=!isassigned(PACKAGE_REQUESTS_BY_DATE_PATH))
    if redownload
        println("Downloading package request logs")
        url = "https://julialang-logs.s3.amazonaws.com/public_outputs/current/package_requests_by_date.csv.gz"
        PACKAGE_REQUESTS_BY_DATE_PATH[] = Downloads.download(url)
    end
    CSV.read(PACKAGE_REQUESTS_BY_DATE_PATH[], DataFrame)
end


const DOWNLOADS_BY_UUID = Dict{UUID, Int}()
"""
    downloads(package)

The number of times a package has been downloaded in the past year.

Multiple downloads from the same IP on the same day are counted as one
CI downloads and requests for unavailable packages are not counted.
"""
function downloads(package)
    if isempty(DOWNLOADS_BY_UUID)
        df = package_requests_by_date()
        filter!(df) do row
            !ismissing(row.client_type) && row.client_type == "user" && row.status == 200 &&
                row.date >= today() - Year(1)
        end
        gdf = groupby(df, :package_uuid)
        df = combine(gdf, :request_addrs => sum)

        for row in eachrow(df)
            DOWNLOADS_BY_UUID[UUID(row.package_uuid)] = row.request_addrs_sum
        end
    end
    get(DOWNLOADS_BY_UUID, uuid(package), 0)
end
